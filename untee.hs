import Control.Monad (forever, mapM_)
import Control.Concurrent (forkIO)
import System.IO (openFile, hGetLine, Handle, IOMode(..))
import System.Environment (getArgs)

import Pipes.Concurrent
import Pipes.Prelude
import Pipes

readPipe outbox fn = do
  h <- openFile fn ReadMode
  forkIO $ runEffect $ fromHandle h >-> toOutput outbox

main :: IO ()
main = do
  (outbox, inbox) <- spawn Unbounded
  getArgs >>= mapM_ (readPipe outbox)
  runEffect $ fromInput inbox >-> stdoutLn
