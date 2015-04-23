import Control.Monad (forever, mapM_)
import Control.Concurrent (forkIO)
import System.IO (openFile, hGetLine, Handle, IOMode(..), stdin)
import System.Environment (getArgs)

import Pipes.Concurrent
import Pipes.Prelude
import Pipes

getHandle :: String -> IO Handle
getHandle "-" = return stdin
getHandle fn  = openFile fn ReadMode

forkReadPipe outbox fn = do
  h <- getHandle fn
  forkIO $ runEffect $ fromHandle h >-> toOutput outbox

main :: IO ()
main = do
  (outbox, inbox) <- spawn Unbounded
  getArgs >>= mapM_ (forkReadPipe outbox)
  runEffect $ fromInput inbox >-> stdoutLn
