module Main where
import Parser
import Lexer
import System.Environment
import System.Exit
import Control.Exception
import Control.Monad
import Typing2

main =
  catch
  (do args <- getArgs
      let argFile =
            case args of
              ["--parse-only",f] -> f
              [f] -> f
              _ -> (error  "usage : petitghc [--parse-only] file")
      if (take 3 . reverse $  argFile) /= "sh." then error "Error : filename must end in .hs" else return ()
      file <- readFile argFile
      case alexScanTokens (('\n':file) ++ "\n")>>= parser of
        Right x -> exitSuccess
        Left (l,c)  -> (putStrLn $ "File \"" ++ argFile ++ "\", line " ++ (show (l-1)) ++ ", characters " ++ (show (c-1)) ++ "-" ++ (show c) ++ ":\nsyntax error" ) >> (exitWith . ExitFailure $ 1)
  )
  (\e -> case fromException e :: Maybe ExitCode of
      Just _ -> throwIO e
      Nothing -> print e >> (exitWith $ ExitFailure 2)
  )



test = (alexScanTokens >=> parser >=> (return . w))
