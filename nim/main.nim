when isMainModule:
# mutable
  var
    greet: string = "hello, world"
    msg: string = "I come in peace!"

# immutable
  let num: int = 1_000_000

# constant -- computed at compile time
  const PI = 3.14159265


#[
    `when` is compile time `if`
    `discard` bypasses unused expressions complains of compiler
    `const` vars must be known during comile time
  ]#

#
# Data structures
#

# tuples
  var
    person: tuple[name: string, age: int]
    animal: tuple[spicies: string, legs: int]

  person = (name: "John", age: 25)
  animal.spicies = "dog"
  animal.legs = 4

# sequences
  var fruits: seq[string]
  fruits = @["apple", "pear", "melon"]
  fruits.add("tangerine")

  if "pear" in fruits:
    echo "there is a pear among ", fruits.len, "fruits"

  let my_fruit = fruits[1]

  echo(greet, msg)

