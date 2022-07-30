import solutions._

object Main {
  val DAY: Int = 5

  val DAYS: List[Solve] = List(
    Day1, Day2, Day3, Day4, Day5,
    //    Day6, Day7, Day8, Day9, Day10,
    //    Day11, Day12, Day13, Day14, Day15, Day16, Day17, Day18, Day19, Day20,
    //    Day21, Day22, Day23, Day24, Day25,
  )

  def main(args: Array[String]): Unit = {
    val day: Int = if (args.length != 0) args(0).toInt else DAY

    val sample_name: String = s"src/main/scala/sample/sample-${day}.txt"
    val input_name:  String = s"src/main/scala/input/input-${day}.txt"

    val solve_obj = DAYS(day - 1)

    println(s"> Day ${day}:")
    solve_obj.solve(sample_name, input_name)
  }
}
