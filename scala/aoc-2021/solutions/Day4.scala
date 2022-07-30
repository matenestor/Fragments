package solutions

import scala.collection.mutable.ListBuffer
import scala.io.Source

object Day4 extends Solve {
  private def getInput(filename: String): List[String] = {
    val filestream = Source.fromFile(filename)

    try filestream.getLines().toList.filter(_ != "")
    finally filestream.close()
  }

  private def transformInput(data: List[String]): (List[Int], List[List[List[Int]]]) = {
    // first list is List with random numbers
    val random_numbers: List[Int] = data
      .head
      .split(",")
      .map(_.toInt)
      .toList

    // rest is List with Bingo boards -- which are 2D List, so result is 3D List
    val transformed_data = data
      .drop(1)
      .map(_.trim.split("\\s+"))
      .map(_.map(_.toInt))
      .map(_.toList)
      // create bingo boards -- 5x5 matrices
      .sliding(5, 5)
      .toList

    (random_numbers, transformed_data)
  }

  def part1(random_numbers: List[Int], data: List[List[List[Int]]]): Int = {
    // TODO flatten the boards -> better code readability, no need to keep them 2D
    //    to check columns later use `.sliding(5,5).transpose`

    def findWinningBoard(): (Int, Int) = {
      for (i <- random_numbers.indices) {
        // progressively take bigger slices of random numbers
        val rnum_slice = random_numbers.take(i + 1)
        // create masks for boards to find a winning one
        val mask = data.map(_.map(_.map(x => rnum_slice.contains(x))))

        for (j <- mask.indices) {
          val isWin = mask
            // take board from collection
            .apply(j)
            // connect rows with columns, so they are on same axis
            .concat(mask.apply(j).transpose)
            // check if some is has only `true` values -- all numbers in row/column marked
            .map(_.forall(x => x))
            // check for the one winning value
            .exists(x => x)

          // winning board found, return current called
          // random number index and current board
          if (isWin) {
            println(s"${(Runtime.getRuntime.totalMemory() - Runtime.getRuntime.freeMemory()) / 1024} kB")

            return (i, j)
          }
        }
      }

      return (0, 0)
    }

    val (rnum_idx, board_idx) = findWinningBoard()

    // get a sum of all numbers on the winning board
    val sum_board = data(board_idx).flatten.sum
    // get a sum of called random numbers that were used on the winning board
    val sum_numbers = random_numbers.take(rnum_idx + 1)
      // filter out random numbers that are NOT on the board
      .filter(x => data(board_idx).flatten.contains(x))
      .sum

    (sum_board - sum_numbers) * random_numbers(rnum_idx)
  }

  def part2(random_numbers: List[Int], data: List[List[List[Int]]]): Int = {
    def findWinningBoard(): (Int, Int) = {
      // TODO rewrite this with tail-recursion and get rid of mutable var
      var winning_boards = ListBuffer[(Int, Int)]();

      for (i <- random_numbers.indices) {
        // progressively take bigger slices of random numbers
        val rnum_slice = random_numbers.take(i + 1)
        // create masks for boards to find a winning one
        val mask = data.map(_.map(_.map(x => rnum_slice.contains(x))))

        for (j <- mask.indices) {
          val isWin = mask
            // take board from collection
            .apply(j)
            // connect rows with columns, so they are on same axis
            .concat(mask.apply(j).transpose)
            // check if some is has only `true` values -- all numbers in row/column marked
            .map(_.forall(x => x))
            // check for the one winning value
            .exists(x => x)

          // winning board found, return current called
          // random number index and current board
          if (isWin && !winning_boards.map(_._2).contains(j)) {
            winning_boards.append((i, j))

            // i wonder how this will change with recursive function
            println(s"${(Runtime.getRuntime.totalMemory() - Runtime.getRuntime.freeMemory()) / 1024} kB")
          }
        }
      }

      winning_boards.last
    }

    val (rnum_idx, board_idx) = findWinningBoard()

    // get a sum of all numbers on the winning board
    val sum_board = data(board_idx).flatten.sum
    // get a sum of called random numbers that were used on the winning board
    val sum_numbers = random_numbers.take(rnum_idx + 1)
      // filter out random numbers that are NOT on the board
      .filter(x => data(board_idx).flatten.contains(x))
      .sum

    (sum_board - sum_numbers) * random_numbers(rnum_idx)
  }

  override def solve(sample_name: String, input_name: String): Unit = {
    val data_sample: List[String] = getInput(sample_name);
    val data_input: List[String] = getInput(input_name);

    // random numbers, transformed data
    val (rnum_sample, tfdata_sample) = transformInput(data_sample)
    val (rnum_input, tfdata_input) = transformInput(data_input)

//    println("Sample 1: " + part1(rnum_sample, tfdata_sample))
//    println("Part 1:   " + part1(rnum_input, tfdata_input))
    println("Sample 2: " + part2(rnum_sample, tfdata_sample))
    println("Part 2:   " + part2(rnum_input, tfdata_input))
  }
}
