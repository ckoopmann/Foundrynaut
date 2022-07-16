object "MagicNumberSolution" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    // Return the number 42
    code {
      mstore(0, 42)
      return(0, 32)
    }
  }
}
