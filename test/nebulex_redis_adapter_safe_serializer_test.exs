defmodule NebulexRedisAdapterSafeSerializerTest do
  use ExUnit.Case

  test "decodes nil" do
    assert NebulexRedisAdapterSafeSerializer.decode_value(nil, []) == nil
  end

  test "decodes safe binary" do
    safe_binary = <<131, 109, 0, 0, 0, 3, 102, 111, 111>>
    assert NebulexRedisAdapterSafeSerializer.decode_value(safe_binary, []) == "foo"
  end

  test "decodes known atoms" do
    safe_binary = :erlang.term_to_binary(:bar)
    assert NebulexRedisAdapterSafeSerializer.decode_value(safe_binary, []) == :bar
  end

  test "passes through on unsafe binary" do
    # this represents an unknown atom
    unsafe_binary = <<131, 119, 11, 117, 110, 107, 110, 111, 119, 110, 97, 116, 111, 109>>

    # NebulexRedisAdapter stores binary values "as-is" in Redis (without encoding)
    # so during decoding we should pass-through the original data on errors rather than raise
    assert is_binary(NebulexRedisAdapterSafeSerializer.decode_value(unsafe_binary))
  end

  test "passes through on executables" do
    # this represents an anonymous function
    unsafe_binary =
      <<131, 112, 0, 0, 0, 211, 0, 74, 179, 14, 23, 76, 2, 152, 184, 122, 207, 206, 42, 63, 68,
        21, 64, 0, 0, 0, 43, 0, 0, 0, 1, 119, 8, 101, 114, 108, 95, 101, 118, 97, 108, 97, 43, 98,
        2, 85, 152, 112, 88, 119, 13, 110, 111, 110, 111, 100, 101, 64, 110, 111, 104, 111, 115,
        116, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 104, 6, 97, 4, 116, 0, 0, 0, 0, 104, 2, 119, 5,
        118, 97, 108, 117, 101, 113, 119, 6, 101, 108, 105, 120, 105, 114, 119, 18, 101, 118, 97,
        108, 95, 108, 111, 99, 97, 108, 95, 104, 97, 110, 100, 108, 101, 114, 97, 2, 104, 2, 119,
        5, 118, 97, 108, 117, 101, 113, 119, 6, 101, 108, 105, 120, 105, 114, 119, 21, 101, 118,
        97, 108, 95, 101, 120, 116, 101, 114, 110, 97, 108, 95, 104, 97, 110, 100, 108, 101, 114,
        97, 3, 116, 0, 0, 0, 0, 108, 0, 0, 0, 1, 104, 5, 119, 6, 99, 108, 97, 117, 115, 101, 97,
        4, 106, 106, 108, 0, 0, 0, 1, 104, 3, 119, 4, 97, 116, 111, 109, 97, 4, 119, 2, 111, 107,
        106, 106>>

    assert is_binary(NebulexRedisAdapterSafeSerializer.decode_value(unsafe_binary, []))
  end
end
