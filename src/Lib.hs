-- | Public interface for the library

module Lib
  (
    parseProblem
  , showProblem
  , solve
  , unfolds
  , unfoldsToLevel
  , historyOfUnfolding
  , readPaper
  )
where

import qualified Data.Tree as T
import qualified Paper
import           Problem
import           Solution
import qualified Solver


solve :: Problem -> Maybe Solution
solve = (fmap (Paper.toSolution . head)) . Solver.solve . Paper.fromProblem


unfolds :: Problem -> [Problem]
unfolds = fmap Paper.toProblem . Paper.unfolds . Paper.fromProblem


unfoldsToLevel :: Int -> Problem -> [Problem]
unfoldsToLevel level = fmap (Paper.toProblem . head) . concat . take (level + 1) . unfoldLevels


historyOfUnfolding :: Int -> Problem -> [Problem]
historyOfUnfolding idx = fmap (Paper.toProblem) . reverse . (!! idx) . concat . unfoldLevels


unfoldLevels :: Problem -> [[[Paper.Paper]]]
unfoldLevels = T.levels . Solver.exploreUnfolds . Paper.fromProblem



readPaper :: Int -> IO Paper.Paper
readPaper n = do
  text <- readFile ("problems/problem_" ++ show n)
  case parseProblem text of
    Right problem -> return $ Paper.fromProblem problem
    _ -> error "couldn't parse problem"
