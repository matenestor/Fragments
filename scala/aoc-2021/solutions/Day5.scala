package solutions

import scala.io.Source

// DOES NOT WORK

object Day5 extends Solve {
  private def getInput(filename: String): List[List[Int]] = {
    val filestream = Source.fromFile(filename)

    try filestream.getLines().toList.filter(_ != "")
      .map(
        _
          .split("(,| -> )")
          .toList
          .map(_.toInt))
    finally filestream.close()
  }

  def expand(foo: List[Int]): List[(Int, Int)] = foo match {
    // TODO is there a better (more readable) way to do this?
    case List(x1,y1,x2,y2) if x1 == x2 && y1 < y2 => List.fill(y2 - y1 + 1)(x1).zip((y1 to y2))
    case List(x1,y1,x2,y2) if x1 == x2 && y1 > y2 => List.fill(y1 - y2 + 1)(x1).zip((y2 to y1))
    case List(x1,y1,x2,y2) if y1 == y2 && x1 < x2 => (x1 to x2).toList.zip(List.fill(x2 - x1 + 1)(y1))
    case List(x1,y1,x2,y2) if y1 == y2 && x1 > x2 => (x2 to x1).toList.zip(List.fill(x1 - x2 + 1)(y1))
    case _ => Nil
  }

  def part1(data: List[List[Int]]): Int = {
    val res = data
      // filter orthogonal coordinates -- either x1 == x2 or y1 == y2
      .filter(coor => coor(0) == coor(2) || coor(1) == coor(3))
      // expand input coordinates to whole lines of hydrothermal vents
      .map(expand)
      // concat all lines
      .reduceLeft(_ ::: _)
      .groupBy(identity)
      // extract points with multiple occurrences
      .collect { case (key, values) if values.lengthCompare(1) > 0 => key }

    res foreach println

      res.size
  }

  def part2(data: List[List[Int]]): Int = 0

  override def solve(sample_name: String, input_name: String): Unit = {
    val data_sample: List[List[Int]] = getInput(sample_name);
    val data_input: List[List[Int]] = getInput(input_name);

//    println("Sample 1: " + part1(data_sample))
    println("Part 1:   " + part1(data_input))
//    println("Sample 2: " + part2(data_sample))
//    println("Part 2:   " + part2(data_input))
  }
}
