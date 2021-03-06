{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Test.Unit where

import           Prelude                      (($), (.))
import           Data.Foldable                (mapM_)
import           Data.Text                    hiding (toTitle)
import           Data.Text.Titlecase
import           Data.Text.Titlecase.Internal hiding (articles, conjunctions, prepositions)
import qualified Data.Text.Titlecase.Internal as Titlecase
import           Test.Tasty
import           Test.Tasty.HUnit

tests :: TestTree
tests = testGroup "Unit tests" [articles, conjunctions, prepositions]

articles :: TestTree
articles = testGroup "Articles" [articleFirst, articleLast, articleIgnored]

conjunctions :: TestTree
conjunctions = testGroup "Conjunctions" [conjunctionFirst, conjunctionLast, conjunctionIgnored]

prepositions :: TestTree
prepositions = testGroup "Prepositions" [prepositionFirst, prepositionLast, prepositionIgnored]

testTitlecase, testFirst, testLast, testIgnored :: Text -> Assertion
testTitlecase t = titlecase (toLower t) @?= Titlecase t

toTitleFirst :: Text -> Text
toTitleFirst t = unwords $ case words t of
  []     -> []
  (x:xs) -> toTitle x : xs

toTitleLast :: Text -> Text
toTitleLast t = unwords $ go $ words t
  where
    go []     = []
    go [x]    = [toTitle x]
    go (x:xs) = x : go xs

testFirst   t = testTitlecase $ toTitleFirst t <#> "Is First, so It Is Capitalized"
testLast    t = testTitlecase $ "This Sentence Capitalizes" <#> toTitleLast t
testIgnored t = testTitlecase $ "This Sentence Keeps" <#> t <#> "as Is"

articleFirst, articleLast, articleIgnored :: TestTree
articleFirst   = testCase "article is first"   $ mapM_ (testFirst   . unArticle) Titlecase.articles
articleLast    = testCase "article is last"    $ mapM_ (testLast    . unArticle) Titlecase.articles
articleIgnored = testCase "article is ignored" $ mapM_ (testIgnored . unArticle) Titlecase.articles

conjunctionFirst, conjunctionLast, conjunctionIgnored :: TestTree
conjunctionFirst   = testCase "conjunction is first"   $ mapM_ (testFirst   . unConjunction) Titlecase.conjunctions
conjunctionLast    = testCase "conjunction is last"    $ mapM_ (testLast    . unConjunction) Titlecase.conjunctions
conjunctionIgnored = testCase "conjunction is ignored" $ mapM_ (testIgnored . unConjunction) Titlecase.conjunctions

prepositionFirst, prepositionLast, prepositionIgnored :: TestTree
prepositionFirst   = testCase "preposition is first"   $ mapM_ (testFirst   . unPreposition) Titlecase.prepositions
prepositionLast    = testCase "preposition is last"    $ mapM_ (testLast    . unPreposition) Titlecase.prepositions
prepositionIgnored = testCase "preposition is ignored" $ mapM_ (testIgnored . unPreposition) Titlecase.prepositions
