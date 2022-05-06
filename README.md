# simple-interactive-program

単純な対話プログラムの雛形

対話プログラムは `responder :: String -> ([String] -> [String])` 関数で表現される。
`responder` の実態は、`MachineState` 上の状態遷移系である。

`eval :: MachineState -> [MachineState]` の下請けである `isFinal :: MachineState -> Bool` および `step :: MachineState -> MachineState` を実装すればよい。
