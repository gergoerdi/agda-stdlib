------------------------------------------------------------------------
-- The Agda standard library
--
-- Some examples showing how common combinators from the Function module
-- can be used to perform "Functional Reasoning" similar to what is being
-- described in: https://stackoverflow.com/q/22676703/3168666
------------------------------------------------------------------------

module README.FunctionalReasoning where

-- Function defines a flipped application (_|>_) combinator as well as a
-- type annotation (_∶_) combinator.

open import Function using (_|>_ ; ∋-syntax)

module _ {A B C : Set} {A→B : A → B} {B→C : B → C} where

-- Using the combinators we can, starting from a value, chain various
-- functions whilst tracking the types of the intermediate results.

  A→C : A → C
  A→C a = a
    ∶ A |> A→B
    ∶ B |> B→C
    ∶ C

-- A more concrete example

open import Data.Nat
open import Data.List.Base
open import Data.Char.Base
open import Data.String using (String ; toList ; fromList ; _==_)
open import Function
open import Data.Bool
open import Data.Product as P using (_×_ ; <_,_> ; uncurry ; proj₁)

-- Using a more concrete example, this can give us for instance this
-- decomposition of a function collecting all of the substrings of
-- the input which happen to be palindromes:

subpalindromes : String → List String
subpalindromes str = let Chars = List Char in str
-- first generate the substrings
  ∶ String                 |> toList
  ∶ Chars                  |> inits
  ∶ List Chars             |> concatMap tails
-- then only keeps the ones which are not singletons
  ∶ List Chars             |> filter (λ cs → 2 ≤? length cs)
-- only keep the ones that are palindromes
  ∶ List Chars             |> map < fromList , fromList ∘ reverse >
  ∶ List (String × String) |> boolFilter (uncurry _==_)
  ∶ List (String × String) |> map proj₁
  ∶ List String

open import Agda.Builtin.Equality

_ : subpalindromes "doctoresreverse" ≡ "eve" ∷ "rever" ∷ "srevers" ∷ "esreverse" ∷ []
_ = refl

_ : subpalindromes "elle-meme" ≡ "ll" ∷ "elle" ∷ "mem" ∷ "eme" ∷ []
_ = refl