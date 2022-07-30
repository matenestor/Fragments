package solutions

import scala.io.Source

object Day2 extends Solve {
  private def getInput(filename: String): List[(String, Int)] = {
    val filestream = Source.fromFile(filename)

    try filestream.getLines().toList.filter(_ != "")
      .map(_.split(" "))
      .map(x => (x(0), x(1).toInt))
    finally filestream.close()
  }

  def part1(data: List[(String, Int)]): Int = {
    // separate horizontal and vertical movement
    val (horizontal, vertical): (List[(String, Int)], List[(String, Int)]) =
      data.partition {
        case ("forward", _) => true
        case ("down", _) => false
        case ("up", _) => false
      }

    // sum movement values
    val sum_h: Int = horizontal.map(_._2).sum
    val sum_v: Int = vertical
      .map {
        case ("down", x) => x
        case ("up", x) => -x
      }
      .sum

    sum_h * sum_v
  }

  def part2(data: List[(String, Int)]): Int = {
    // sum only horizontal movement
    val sum_h: Int = data
      .filter(_._1 == "forward")
      .map(_._2)
      .sum

    val sum_v = data
      // create aim changing values
      .map {
        case ("forward", x) => 0
        case ("down", x)    => x
        case ("up", x)      => -x
      }
      // create accumulated aim values
      .scanLeft(0)(_ + _)
      // zip with original data
      .zip(data)
      // movement is only when "forward" comes
      .filter(_._2._1 == "forward")
      // multiply aim with forward value
      .map(x => x._1 * x._2._2)
      .sum

    sum_h * sum_v
  }

  def part2_var(data: List[(String, Int)]): Int = {
    // method with mutable variables (easy solution)

    var (aim, sum_h, sum_v): (Int, Int, Int) = (0, 0, 0)

    for (i <- data) {
      i match {
        case ("forward", x) => {
          sum_h += x
          sum_v += aim * x
        }
        case ("down", x) => aim += x
        case ("up", x)   => aim -= x
      }
    }

    sum_h * sum_v
  }

  override def solve(sample_name: String, input_name: String): Unit = {
    val data_sample: List[(String, Int)] = getInput(sample_name);
    val data_input: List[(String, Int)] = getInput(input_name);

    println("Sample 1: " + part1(data_sample))
    println("Part 1:   " + part1(data_input))
    println("Sample 2: " + part2(data_sample))
    println("Part 2:   " + part2(data_input))
  }
}
