/*
@brief Cafe sample for simulating loses in channels
@author Sergey Staroletov serg_soft@mail.ru https://www.researchgate.net/profile/Sergey_Staroletov
@license GNU GPL
*/

/* channels - from the scheme*/
chan gc_to_man = [0] of {short};
chan man_to_gc = [0] of {short};
chan man_to_cook = [0] of {short};
chan cook_to_pincake=[0] of {short};
chan pincake_to_man=[0] of {short};
chan cook_to_kvass=[0] of {short};
chan kvass_to_man=[0] of {short};
chan goods_to_man=[2] of {short};

int count;
int nextClient=0;

int myProb = 30;

active proctype Client(){
do
    ::{
    short buf = 1;
    //nextClient != 1;
    printf("Client: Creating an order to the Manager\n");
    if
        :: [prob = myProb] true -> {gc_to_man ! 1; }
        :: true -> {gc_to_man ! 2; }
    fi;
    printf("Client: Waiting a result from the Manager \n");
    man_to_gc ? buf;
    printf("HungryMan: cycle done");
    }
od
}

active proctype Manager() {
int buf;
count = 0;
do
    :: {
    nextClient = 0;
    printf("Manager: Waiting an order from the customer\n");
    gc_to_man ? buf;
    if
    :: buf == 1 ->  {
        printf("Manager: asking cook for Kvass\n"); man_to_cook ! 1;
        printf("Manager: asking cook for Pincake\n"); man_to_cook ! 2;
    }
    :: buf == 2 -> {
        printf("Manager: asking cook for Pincake\n"); man_to_cook ! 2;
        printf("Manager: asking cook for Kvass\n"); man_to_cook ! 1;
    }
    :: else -> skip;
    fi
    printf("Manager: receiving goods\n");
    goods_to_man?buf;
    goods_to_man?buf;
    printf("Manager: returning result to Client\n ")
    man_to_gc ! 1;
    count++;
    if
      ::count == 1000 -> break;
      ::count == 500 -> myProb = 70;
      ::else-> skip;
    fi
    }
od
}

active proctype Cook () {
int buf;
do
:: {
    printf("Cook: Waiting for a request from Manager\n");
    man_to_cook? buf;
    if
    ::buf ==1 ->
    {
        printf("Cook: cooking kvass\n");
        cook_to_kvass ! 1;
    }
    ::buf == 2 ->
    {
        printf("Cook: cooking pincake\n");
        cook_to_pincake ! 1;
    }
    fi
}
od
}

active proctype Pincake () {
int buf;
do
:: {
    printf("Pincake: receiving a request from Cook\n");
    cook_to_pincake? buf;
    printf("Pincake: sending me to Manager\n");
    goods_to_man ! 1;
}
od
}

active proctype Kvass () {
int buf;
do
:: {
    printf("Kvass: receiving a request from  Cook\n");
    cook_to_kvass? buf;
    printf("Kvass: sending me to  Manager\n");
    goods_to_man ! 2;
}
od
}
