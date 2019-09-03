module Util exposing (flip)

-- Flips the parameters of the given function


flip : (a -> b -> c) -> b -> a -> c
flip fn b a =
    fn a b
