import Array._

object Main {

  def main(args: Array[String]): Unit = {
    val result = LazyList.iterate(3, 5)(x => x + 100);
    println(result);
    result.foreach(println)
  }
}
