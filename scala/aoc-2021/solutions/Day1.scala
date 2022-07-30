package solutions

import scala.io.Source

object Day1 extends Solve {
  private def getInput(filename: String): List[Int] = {
    val filestream = Source.fromFile(filename)

    try filestream.getLines().toList.filter(_ != "")
      .map(_.toInt)
    finally filestream.close()
  }

  def part1(data: List[Int]): Int =
    data
      // create pairs of neighbour elements
      .sliding(2)
      // check if the depth increased
      .collect(x => x(0) < x(1))
      // count how many times the depth increased
      .count(_ == true)

  def part2(data: List[Int]): Int =
    data
      // create triples of neighbour elements
      .sliding(3)
      // sum elements in windows
      .map(_.sum)
      // create pairs again for comparing
      .sliding(2)
      // check if the depth increased
      .collect(x => x(0) < x(1))
      // count how many times the depth increased
      .count(_ == true)

  override def solve(sample_name: String, input_name: String): Unit = {
    val data_sample: List[Int] = getInput(sample_name);
    val data_input: List[Int] = getInput(input_name);

    println("Sample 1: " + part1(data_sample))
    println("Part 1:   " + part1(data_input))
    println("Sample 2: " + part2(data_sample))
    println("Part 2:   " + part2(data_input))
  }
}
