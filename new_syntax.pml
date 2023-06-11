int tt = 80;
int pp = 45;

init {
	atomic {
	run receiver();
	}
}

proctype receiver() {
  int count = 10000;
  int pp10 = 0;
  int pp20 = 0;
  int pp70 = 0;
  int pp23 = 0;

  pp = 20;
  do
      ::(count > 0) -> {
      if
          :: [prob = 10%] true -> pp10++;

          :: [prob = pp] true -> pp20++;

      fi;
          count--;
      }
      ::else -> {
        break;
      };
  od;
  printf("Total1 : pp10 = %d pp20 = %d pp70 = %d and pp23 = %d \n", pp10/100, pp20/100, pp70/100, pp23/100);

}