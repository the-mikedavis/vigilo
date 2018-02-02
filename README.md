# Vigilo

Vigilo is a project to help my roommate and I figure out who is in the room
and when. By registering a phone's bluetooth, vigilo can leverage command line
tools to see who's in the room.

<small>If you've never had a roomy in a relationship, you probably won't
understand the significance of this project.</small>

### How it works

Vigilo works by using the `hcitool` on a Raspberry PI 3 running Ubuntu MATE.
The RP3 is connected to a device (I have an iPhone) so that both trust each 
other. Once the RP3 trusts the (bluetooth) MAC address of the phone, it stores
its name and MAC for future reference.

Once trusted, you can use the `hcitool`'s `name` verb to lookup the name of a
MAC address. The catch is... it only works when the device is nearby. While
that might seem like a drawback, it's exactly what makes Vigilo work.

Vigilo calls `hcitool name <MAC>` every 30 seconds for each device. Looking up
the name initiates a handshake protocol that gives away the device's name, or
the empty string if the device doesn't exist. Vigilo simply feeds `hcitool` a
list of names and parses the output. I got the guts of this from
[this](https://raspberrypi.stackexchange.com/a/42544) answer on the Raspberry
Pi SE site. Once you have the output, it's fairly easy to pump it into a
template and ship it off.

There's one catch though when building the server: `hcitool` can be
slow. Like _really_ slow, sometimes taking up to 5 seconds to finish. You very
well can't have an HTTP request sitting in your server for 5 seconds, even if
your audience consists of two people.

To solve this, I scan using Jose Valim's answer
[here](https://stackoverflow.com/a/32097971/7242773), on using a `GenServer`
to store the state of the room. The state is just a list of `struct`s with
`name`, `mac`, and `present` fields. The `GenServer` uses the `handle_info`
call to do work on its own, and then schedules itself to run 30 seconds after
it finishes to start all over again. Later, the controller can access that
process with `call`, which simply returns the state. So any user requesting
the webpage isn't requesting a scan. They're requesting the state, which
could be up to around 29 seconds old.

### Try it yourself

Clone me (into `~` for example). Create a file for the MACs
(`~/vigilo/config/macs.secret.exs`). Fill it with something like this:

```elixir
use Mix.Config
config :vigilo, macs: ["<MAC1>", "<MAC2">, ...]
```

Now add this before the last line of `config/config.exs`:

```elixir
import_config "macs.secret.exs"
```

And start up the server! (`mix phx.server`)

