module AbstractSyn where
import Parser
import DTCleaner

syn = do
    contents <- getContents
    putStrLn $ show $ semPExp $ getTree contents
