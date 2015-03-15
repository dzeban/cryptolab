## Факт ##

Реализация простейшего алгоритма RSA заняла 176 строк кода.


### Исходный код (при линковке надо делать -lgmp) ###
```
#include <gmp.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define LEN 1000

void phi(mpz_t fi, const mpz_t p, const mpz_t q)
{
  mpz_t pp;
  mpz_init (pp);
  
  mpz_t qq;
  mpz_init (qq);
  
  mpz_set(pp, p);
  mpz_set(qq, q);
  
  mpz_sub_ui(pp, pp, 1);
  mpz_sub_ui(qq, qq, 1);
  
  mpz_mul(fi, pp, qq);
  mpz_clear(pp);
  mpz_clear(qq);
}

int main()
{
  /*Реализация криптосистемы RSA на одной вычислителной машине*/

  /*
   * Field F{int}    Создаем поле F
   */
  unsigned long seed;
  gmp_randstate_t state;
  seed = time(NULL); // system time
  gmp_randinit_default(state);
  gmp_randseed_ui(state, seed);
  
  unsigned int length;
  unsigned int count;
  
  /*
   * p<-F{len = 1000b}   Берем случайный простой p из F длиной 1000 бит
   */
  mpz_t p;
  mpz_init (p);
  mpz_urandomb (p, state, LEN);
  mpz_nextprime(p,p);
  gmp_printf ("p:\t%Zd\n\n", p);
  /*************************************************************/

  /*
   * q<-F{len = 1000b}   Берем случайный простой q из F длиной 1000 бит
   */
  mpz_t q;
  mpz_init (q);
  mpz_urandomb (q, state, LEN);
  mpz_nextprime(q,q);
  gmp_printf ("q:\t%Zd\n\n", q);  
  /*************************************************************/
  
  /*
   * n = p*q             n = произведение p на q
   */
  mpz_t n;
  mpz_init (n); 
  mpz_mul(n, p, q);
  gmp_printf ("n:\t%Zd\n\n", n);
  /*************************************************************/

  /*
   * fi = phi(p,q)     fi = функция эйлера от аргументов p и q
   */
  mpz_t fi;
  mpz_init (fi);
  phi(fi, p, q);
  gmp_printf ("fi:\t%Zd\n\n", fi);  
  /*************************************************************/
  
 
  /*
   * e<-[1,fi-1];      Берем случайное e взаимно-простое с fi
   */
  mpz_t e;
  mpz_init (e);
  
  mpz_t gcd;
  mpz_init (gcd);
  
  unsigned long int e_int = 65537;

  while(1) {
    mpz_gcd_ui (gcd,fi,e_int);
    if(mpz_cmp_ui (gcd, 1)==0)
      break;
    /* try the next odd integer... */
    e_int += 2;
  }
  mpz_set_ui(e,e_int);
  gmp_printf ("e:\t%Zd\n\n", e);  
  /*************************************************************/
  

  /*
   * d = mul_inv(e,fi)  d = мультипликативно обратное от e по модулю fi
   */
  mpz_t d;
  mpz_init (d);
  mpz_invert (d, e, fi);
  gmp_printf ("d:\t%Zd\n\n", d);
  /*************************************************************/
 

  /*
   * echo "Please type number to encrypt:"  ввод пользователя
   */
  printf("Please type number to encrypt:\n\t");

  /*
   * m = scan(stdin,int)           считываем с клавиатуры 
   */
  char *input;
  int nbytes=LEN;
  int bytes_read;
  input = (char *) malloc (nbytes + 1);
  int num;
  
  bytes_read = getline (&input, &nbytes, stdin);
  
  mpz_t m;
  mpz_init (m);
  mpz_set_str (m, input, 10);
  /*************************************************************/
 

  /*
   * c = m^e(mod n)    шифруем: с = m в степени e по модулю n
   */
  mpz_t c;
  mpz_init (c);
  mpz_powm (c, m, e, n);
  gmp_printf ("c:\t%Zd\n\n", c);
  /*************************************************************/

  /*
   * mm = c^d(mod n) расшифровываем
   */
  mpz_t mm;
  mpz_init (mm);
  mpz_powm (mm, c, d, n);
  gmp_printf ("mm:\t%Zd\n\n", mm);
  /*************************************************************/

  /*
   * if(mm == m) echo "!!!Perfect!!!\n"       //сравниваем сообщения
   *     else echo "!!!Error!!!\n"
   */
  if (!mpz_cmp(m,mm)) printf("!!!Perfect!!!\n");
    else printf("!!!Error!!!\n");
  
  /*
   * Clear all
   */
  gmp_randclear(state);
  mpz_clear (p);
  mpz_clear (q);
  mpz_clear (n);
  mpz_clear (fi);
  mpz_clear (e);
  mpz_clear (d);
  mpz_clear (m);
  mpz_clear (c);
  mpz_clear (mm);
  return 0;
}
```