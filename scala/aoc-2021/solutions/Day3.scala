package solutions

import scala.annotation.tailrec
import scala.io.Source

object Day3 extends Solve {
  private def getInput(filename: String): List[List[Int]] = {
    val filestream = Source.fromFile(filename)

    try filestream.getLines().toList.filter(_ != "")
      // transform parsed lines to lists with ints
      .map(
        _
          .split("")
          .map(_.toInt)
          .toList
      )
    finally filestream.close()
  }

  def part1(data: List[List[Int]]): Int = {
    val half: Int = data.length / 2

    val computed: List[String] = data
      // sum values on y axis
      .transpose
      .map(_.sum)
      // more common bit has over half occurrences in data
      // also possible like this:
      // .map(x => if (x < amount) ("0", "1") else ("1", "0"))
      // but default case to be sure
      .map {
        case x if x < half  => List("0", "1")
        case x if x > half  => List("1", "0")
        case x if x == half => List("unreachable", "unreachable")
      }
      // create strings from values on y axis
      .transpose
      .map(_.mkString)

    val gamma_rate: Int = Integer.parseInt(computed.head, 2)
    val epsilon_rate: Int = Integer.parseInt(computed.last, 2)

    gamma_rate * epsilon_rate
  }

  def part2(data: List[List[Int]]): Int = {
    @tailrec
    def find_rating(measuring: List[List[Int]],
                    predicate: (Int, Float) => Boolean,
                    common_val: Int,
                    idx: Int):
    List[Int] = {
      if (measuring.length == 1) {
        // last value
        measuring.head
      }
      else {
        val half: Float = measuring.length / 2f
        // amount of ones on y axis in measured data
        val ones: Int = measuring
          .transpose
          .lift(idx)
          .head
          .sum

        // Filter with given `predicate` according to if the "oxygen generator
        // rating" is searched -- most common value (bit) is wanted,
        // or the "CO2 scrubber rating" is searched -- least common value is wanted.
        // If the amounts of 1s and 0s are same, then the "common value" is used.
        find_rating(measuring.filter(x => x match {
            case x if  predicate(ones, half)                   => x(idx) == 0
            case x if !predicate(ones, half) && (ones != half) => x(idx) == 1
            case _                                             => x(idx) == common_val
          }),
          predicate, common_val, idx + 1)
      }
    }

    // predicate anonymous functions used to compare amount of 1s and 0s,
    // in order to find the most or the least common bit
    // val predicate_most_common_value: (Int, Float) => Boolean = _ < _
    // val predicate_least_common_value: (Int, Float) => Boolean = _ > _

    // most common value; if equally common, then 1
    val oxygen_generator_rating: Int =
      Integer.parseInt(find_rating(data, (_ < _), 1, 0).mkString, 2)

    // least common value; if equally common, then 0
    val co2_scrubber_rating: Int =
      Integer.parseInt(find_rating(data, (_ > _), 0, 0).mkString, 2)

    oxygen_generator_rating * co2_scrubber_rating
  }

  override def solve(sample_name: String, input_name: String): Unit = {
    val data_sample: List[List[Int]] = getInput(sample_name);
    val data_input: List[List[Int]] = getInput(input_name);

    println("Sample 1: " + part1(data_sample))
    println("Part 1:   " + part1(data_input))
    println("Sample 2: " + part2(data_sample))
    println("Part 2:   " + part2(data_input))
  }
}
