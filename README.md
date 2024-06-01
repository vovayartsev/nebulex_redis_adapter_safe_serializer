# NebulexRedisAdapterSafeSerializer

When using Nebulex cache library with Redis, in certain rare scenarios it's possible to execute arbitrary
Elixir code by writing a malcious value to Redis.

See https://paraxial.io/blog/elixir-rce and https://github.com/cabol/nebulex_redis_adapter/issues/59 for more details. 

This library prevents decoding data that can be used to attack the Erlang runtime.
In the event of receiving unsafe data, the original un-encoded string (binary) is returned.

Note: Erlang's `binary_to_term` treats unknown atoms as "unsafe" data.

## Installation

1. Install the package by adding `nebulex_redis_adapter_safe_serializer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nebulex_redis_adapter_safe_serializer, github: "vovayartsev/nebulex_redis_adapter_safe_serializer"}
  ]
end
```

2. Configure you Nebulex cache to use the safe serializer in `config.exs`:

```
config :your_app, YourApp.YourCache
  conn_opts: [...],
  serializer: NebulexRedisAdapterSafeSerializer
```


