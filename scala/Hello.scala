import Array._

object Hello {
  def fizzbuzz(): Unit = {
    val fizz = "fizz";
    val buzz = "buzz";
    val fizzbuzz = "fizz buzz";

    for (i <- 1 to 30) {
      val three = i % 3 == 0;
      val five = i % 5 == 0;

      if (three && five) {
        println(fizzbuzz);
      }
      else if (three) {
        println(fizz);
      }
      else if (five) {
        println(buzz);
      }
      else {
        println(i);
      }
    }
  }

  private def transform_array_iterative(num: Int, str: String, arr: Array[Int]): Array[String] = {
    var ret_a = Array.ofDim[String](arr.length / 2 + 1);
    var j = 0;

    for (i <- arr.indices if arr(i) % 2 == 0) {
      ret_a(j) = s"${str}${arr(i) * num}";
      j += 1;
    }

    return ret_a;
  }

  private def transform_array_functional(num: Int, str: String, arr: Array[Int]): Array[String] = {
    return arr
            .filter(_ % 2 == 0)
            .map(_ * 2)
            .map(x => s"${str}${x}");
  }

  def transform_arrays(): Unit = {
    println(transform_array_iterative(2, "hey", range(0, 11)).mkString(", "));
    println(transform_array_functional(2, "hey", range(0, 11)).mkString(", "));
  }

  private def comp(fce: Int => Long, fce_name: String): Unit = {
    val start: Int = 0;
    val amount: Int = 50;

    val time = System.nanoTime;

    val list: LazyList[Long] = LazyList
      .from(start)
      .take(amount)
      .map(Fibonacci.fibo_nth);

    println(f"> ${fce_name}: ${(System.nanoTime - time) / 1e9} s");

    list foreach print;
    println;
  }

  def measure_fibonacci(): Unit = {
    comp(Fibonacci.fibo_tailrec, "fibo_tailrec")
    comp(Fibonacci.fibo_iter, "fibo_iter")
    comp(Fibonacci.fibo_nth, "fibo_nth")
  }
}
