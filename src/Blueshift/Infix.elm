module Blueshift.Infix
  ( (<$>)
  , (>>=)
  , (<|>)
  ) where

{-|

@docs (<$>), (>>=), (<|>)
-}

import Blueshift.Core as Impl

type alias Parser a = Impl.Parser a

{-| -}
(<$>) : (a -> b) -> Parser a -> Parser b
(<$>) = Impl.map

{-| -}
(>>=) : (a -> Parser b) -> Parser a -> Parser b
(>>=) = flip Impl.andThen

{-| -}
(<|>) : Parser a -> Parser a -> Parser a
(<|>) = Impl.or
