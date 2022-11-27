import std/[strutils]
import std/[algorithm, sequtils]


const
  SIZE: int = 4
  ASCII_A: int = 97

#[ my attempt to create a (redundant) generic array:

  #type Matrix[W, H: static[int]] = array[1..W, array[1..H, int]]

  # `n: int` is a generic constraint of a type not a value
  # `n: static[int]` is a value

  type GenericArray[n: static int, T: int|string] = array[n, T]
  var mi: GenericArray[3, int]
  var ms: GenericArray[3, string]
  echo mi
  echo ms
]#

# 'num: static[int]' tells compiler that 'num' is compile time value
# a compiler is probably smart enough to understand this with arrays
type
  Board = array[SIZE, array[SIZE, int]]
  Coordinates = tuple[from_x, from_y, to_x, to_y: int]

# TODO resizeable board
var
  board: Board = [
    [2, 0, 0, 1],
    [0, 2, 1, 0],
    [0, 1, 2, 0],
    [1, 0, 0, 2],
  ]
  last_switch: Coordinates


proc render_board() =
  #   ---------
  # 4 |X| | |O|   4 X _ _ O
  #   ---------   3 _ X O _
  # 3 | |X|O| |   2 _ O X _
  #   ---------   1 O _ _ X
  # 2 | |O|X| |
  #   ---------     A B C D
  # 1 |O| | |X|
  #   ---------
  #    A B C D
  #

  #for row in reversed(board):
  #  echo row

  # reversed to the Y axis matches what is displayed to a user
  for i in countdown(SIZE - 1, 0):
    stdout.write i + 1

    for field in board[i]:
      case field
      of 0:
        stdout.write " _"
      of 1:
        stdout.write " O"
      of 2:
        stdout.write " X"
      else:
        # unreachable
        stdout.write "?"
    echo ""
  echo "\n  A B C D"

  echo ""


proc render_board(player: bool) =
  echo "------------------------------"
  echo "Player: ", if player: "O (white)" else: "X (black)"
  echo ""
  render_board()


# TODO input for AIs
proc get_input(): string =
  stdout.write "Your move: "
  return stdin.readLine()


# TODO REPL?
proc parse_terminal_input(input: string): Coordinates =
  return (
    from_x: int(toLowerAscii(input[0])) - ASCII_A,
    from_y: parseInt($input[1]) - 1,
    to_x: int(toLowerAscii(input[2])) - ASCII_A,
    to_y: parseInt($input[3]) - 1,
  )


proc get_move(input: string): (Coordinates, bool) =
  var
    move: Coordinates
    ok_move: bool = false

  try:
    move = parse_terminal_input(input)
    ok_move = true
  except IndexDefect:
    echo "Insufficient input!"
  except ValueError:
    echo "Incorrect input!"
  except:
    echo "Unknown exception.."

  return (move, ok_move)


proc is_valid_switch(
  player: bool, m: Coordinates, last_switch: Coordinates
): (bool, Coordinates) =
  # in case the move is not a switch, then the last switch should be discarded
  let player_id: int = if player: 1 else: 2
  var switch: Coordinates = (-1, -1, -1, -1)

  # TODO DRY in is_valid_move() -> is_in_rules()
  let
    from_in_range: bool = m.from_x in 0..<SIZE and m.from_y in 0..<SIZE
    to_in_range: bool = m.to_x in 0..<SIZE and m.to_y in 0..<SIZE
  if not (from_in_range and to_in_range):
    echo "Coordinates are outside of the board!"
    return (false, last_switch)

  if board[m.from_y][m.from_x] != player_id:
    echo "Not your stone to move or no stone at all!"
    return (false, last_switch)

  let
    same_x: bool = m.from_x == m.to_x
    same_y: bool = m.from_y == m.to_y
  if same_x and same_y:
    echo "Cannot stay in one place!"
    return (false, last_switch)
  if not (same_x xor same_y):
    echo "Can move only in a straight line!"
    # return the last performed switch in order to keep the state
    return (false, last_switch)

  # switching a piece with an opponent
  if abs(m.from_x - m.to_x) == 1 or abs(m.from_y - m.to_y) == 1:
    if board[m.from_y][m.from_x] == board[m.to_y][m.to_x]:
      echo "Cannot switch your own pieces!"
      return (false, last_switch)
    elif m == last_switch:
      echo "Cannot repeat the same switch!"
      return (false, last_switch)
    else:
      # valid switch
      switch = m
  else:
    return (false, switch)

  return (true, switch)

proc is_valid_move(player: bool, m: Coordinates): bool =
  let player_id: int = if player: 1 else: 2

  let
    from_in_range: bool = m.from_x in 0..<SIZE and m.from_y in 0..<SIZE
    to_in_range: bool = m.to_x in 0..<SIZE and m.to_y in 0..<SIZE
  if not (from_in_range and to_in_range):
    echo "Coordinates are outside of the board!"
    return false

  if board[m.from_y][m.from_x] != player_id:
    echo "Not your stone to move or no stone at all!"
    return false

  let
    same_x: bool = m.from_x == m.to_x
    same_y: bool = m.from_y == m.to_y

  if same_x and same_y:
    echo "Cannot stay in one place!"
    return false

  if not (same_x xor same_y):
    echo "Can move only in a straight line!"
    return false

  # TODO eeh.. clean this up, another macro?
  # +/- 1 so that the field, where the stone stands, is not included
  if same_x:
    let fields: seq[int] = if m.from_y < m.to_y:
      toSeq(countup(m.from_y + 1, m.to_y)) else:
      toSeq(countdown(m.from_y - 1, m.to_y))

    for i in fields:
      if board[i][m.from_x] != 0:
        echo "Cannot move through pieces!"
        return false
  elif same_y:
    let fields: seq[int] = if m.from_x < m.to_x:
      toSeq(countup(m.from_x + 1, m.to_x)) else:
      toSeq(countdown(m.from_x - 1, m.to_x))

    for i in fields:
      if board[m.from_y][i] != 0:
        echo "Cannot move through pieces!"
        return false
  else:
    echo "Unreachable!"
    return false

  return true


proc move_piece(m: Coordinates) =
  # swap 'from' and 'to' coordinate
  # TODO this will not work for moves, which capture other pieces
  #  or move on top of other pieces etc.
  (board[m.from_y][m.from_x], board[m.to_y][m.to_x]) =
    (board[m.to_y][m.to_x], board[m.from_y][m.from_x])


proc player_win(player: bool): bool =
  let player_id: int = if player: 1 else: 2
  var amount: int = 0

  # TODO check for the opponent win if a current player switches peices
  #   that lead to losing the game
  # TODO would a macro solve this repetition?

  # horizontal lines
  for i in 0..<SIZE:
    amount = 0
    # TODO how to do this also for the vertical lines?:
    #  if all(row, proc (x: int): bool = x == player_id): return true
    for j in 0..<SIZE:
      if board[i][j] == player_id:
        inc amount
      else:
        break

    if amount == SIZE:
      return true

  # vertical lines
  for i in 0..<SIZE:
    amount = 0
    for j in 0..<SIZE:
      if board[j][i] == player_id:
        inc amount
      else:
        break

    if amount == SIZE:
      return true

  return false


proc render_result(player: bool) =
  echo "------------------------------"
  echo ""
  render_board()
  echo if player: "O (white) " else: "X (black) ", "player won!"


proc main() =
  var
    # white: true/1, black: false/2
    player: bool = true
    last_switch: Coordinates = (-1, -1, -1, -1)
    valid_switch: bool

  while true:
    # render to terminal or gui or web
    render_board(player)
    # input from terminal or gui or web or AI
    let input = get_input()
    # transform input to move coordinates
    let (move, ok_move) = get_move(input)

    if not ok_move:
      continue

    (valid_switch, last_switch) = is_valid_switch(player, move, last_switch)

    if valid_switch:
      move_piece(move)
    elif is_valid_move(player, move):
      move_piece(move)
    else:
      continue

    if player_win(player):
      render_result(player)
      break

    player = not player


when isMainModule:
  main()

