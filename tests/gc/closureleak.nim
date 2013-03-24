discard """
  outputsub: "true"
"""

from strutils import join

type
  TFoo * = object
    id: int
    func: proc(){.closure.}
var foo_counter = 0
var alive_foos = newseq[int](0)

proc free*(some: ref TFoo) =
  #echo "Tfoo #", some.id, " freed"
  alive_foos.del alive_foos.find(some.id)
proc newFoo*(): ref TFoo =
  new result, free
  
  result.id = foo_counter
  alive_foos.add result.id
  inc foo_counter

for i in 0 .. <10:
 discard newFoo()

for i in 0 .. <10:
  let f = newFoo()
  f.func = proc = 
    echo f.id

gc_fullcollect()
echo alive_foos.len <= 2
