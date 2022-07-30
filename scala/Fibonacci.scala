import Array._

object Fibonacci {
  val sqrt_5: Double = math.sqrt(5);
  val phi: Double = (1 + sqrt_5) / 2;
  val psi: Double = (1 - sqrt_5) / 2;

  // ------------------------------------------------------

  def fibo_nth(n: Int): Long = {
    return ((math.pow(phi, n) - math.pow(psi, n)) / sqrt_5).toLong;
  }

  // ------------------------------------------------------

  private def fibo_go(n: Int, arr: Array[Long]): Long = {
    if (n > 1)
      return fibo_go(n - 1, Array(arr(1), arr(0) + arr(1)));
    return arr(n);
  }

  def fibo_tailrec(n: Int): Long = {
    return fibo_go(n, Array(0, 1));
  }

  // ------------------------------------------------------

  def fibo_iter(n: Int): Long = {
    var n1: Long = 0L;
    var n2: Long = 1L;
    var tmp: Long = 0L;

    for (_ <- Range(0, n)) {
      tmp = n2;
      n2 = n1 + n2;
      n1 = tmp;
    }

    return n1;
  }
}
