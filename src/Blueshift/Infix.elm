module Blueshift.Infix exposing
  ( (<$>), (>>=), (<|>), (<*>), (<*), (*>), (>>>)
  )

{-|

@docs (<$>), (>>=), (<|>), (<*>), (<*), (*>), (>>>)
-}

import Blueshift.Core as Core

type alias Parser a = Core.Parser a

{-|-}
(<$>) : (a -> b) -> Parser a -> Parser b
(<$>) = Core.map
infixl 4 <$>

{-|-}
(>>=) : Parser a -> (a -> Parser b) -> Parser b
(>>=) = Core.andThen
infixl 1 >>=

{-|-}
(<|>) : Parser a -> Parser a -> Parser a
(<|>) = Core.or
infixr 3 <|>

{-|-}
(<*>) : Parser (a -> b) -> Parser a -> Parser b
(<*>) = Core.andMap
infixl 4 <*>

{-|-}
(*>) : Parser a -> Parser b -> Parser b
(*>) = Core.followedBy
infixl 4 *>

{-|-}
(<*) : Parser a -> Parser b -> Parser a
(<*) p q = p `Core.andThen` \r -> q `Core.andThen` \_ -> Core.succeed r
infixl 4 <*

{-|-}
(>>>) : Parser a -> Parser b -> Parser b
(>>>) = Core.followedBy
infixl 1 >>>

{-|-}
(<?>) : Parser a -> String -> Parser a
(<?>) = Core.annotate
infix 0 <?>
