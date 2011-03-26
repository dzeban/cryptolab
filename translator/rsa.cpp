//TODO: Add #ifdef DEBUG cases to routines
//with debug output
#include <gmpxx.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
using namespace std;
#define LEN 1000

// Get prime number size of given bits
mpz_class prime(unsigned int bits)
{
	// Initialize random generator
	gmp_randclass generator(gmp_randinit_default);
	unsigned long seed = time(NULL);
#ifdef DEBUG
	printf("Initializing random generator with seed value %ld\n", seed);
#endif
	generator.seed(seed);
	
	// Generate random integer with specified bits
	mpz_class rand = generator.get_z_bits(bits);
	mpz_nextprime(rand.get_mpz_t(), rand.get_mpz_t());

#ifdef DEBUG
	cout << "Generated prime:" <<  rand.get_str() << endl;
#endif
	
	return rand;
}

// Calculate Euler's phi function
// WARNING: Input values 'p' and 'q' both MUST be prime
mpz_class phi(mpz_class p, mpz_class q)
{
/*
 *    mpz_class pp(p);
 *    mpz_class qq(q);
 *
 *    pp = pp-1;
 *    qq = qq-1;
 */

	return (p-1)*(q-1);
}

// Return random value from interval
//
//FIXME: Of course first argument should be mpz_class
mpz_class assign(int from, mpz_class to)
{
	unsigned long int e_int = 65537;
	mpz_class gcd;
#ifdef DEBUG
	cout << "Choosing random value from [" << from << "," << to.get_str() << "]" << endl;
#endif
	while(1)
	{
		// FIXME: check if there should be "to" or "to+1"
		// because in rsa.c in case of "fi-1" we take here just "fi"
		mpz_gcd_ui(gcd.get_mpz_t(), to.get_mpz_t(), e_int);

		if(gcd == 1)
			break;

		e_int += 2;
	}

	mpz_class result(e_int);

#ifdef DEBUG
	cout << "Choosed random value: " << result.get_str() << endl;
#endif

	return result;
}

// Calculate multiplicative inverse of 'val' by 'mod' modulo
mpz_class mul_inv(mpz_class val, mpz_class modulo)
{
	mpz_class result;
	
	mpz_invert(	result.get_mpz_t(), 
				val.get_mpz_t(), 
				modulo.get_mpz_t()
			  );
#ifdef DEBUG
	cout << val.get_str() << " multiplicative inverse is " << result.get_str() << endl;	
#endif

	return result;
}

// Scanning in given file
// FIXME: should be more general
mpz_class scan(FILE *stream)
{
	char *input = NULL;
	size_t len = 0;
	int bytes_read;
	//TODO: Check if getline is non-POSIX
	
	if(getline (&input, &len, stream))
	{
		// If getline was successful define result value
		mpz_class result(input);
#ifdef DEBUG
		cout << "Scanned line is " << result.get_str() << endl;
#endif
		return result;
	}
}

// Power by modulo for mpz_class
mpz_class powm(mpz_class base, mpz_class exp, mpz_class mod)
{
	mpz_class result;
#ifdef DEBUG
	cout << "Powering " << base.get_str() << endl 
			"in "		<< exp.get_str() << endl
			"by modulo"	<< mod.get_str() << endl;
#endif
	mpz_powm(	result.get_mpz_t(),
				base.get_mpz_t(),
				exp.get_mpz_t(),
				mod.get_mpz_t()
			);
#ifdef DEBUG
	cout << "Powering result: " << result.get_str() << endl;
#endif

	return result;
}

int main(void)
{

	//Реализация криптосистемы RSA на одной вычислителной машине

	//p = prime(1000)										Берем случайные простые элементы p,q
	mpz_class p;
	p = prime(1000);
	//----------------
	
	//q = prime(100)
	mpz_class q;
	q = prime(100);		
	//----------------
	
	//n = p*q;                                        n = произведение p на q
	mpz_class n;
	n = p*q;
	//----------------

	//fi = phi(p,q);                                  fi = функция эйлера от аргументов p и q
	mpz_class fi;
	fi = phi(p,q);
	//----------------

	//e<-[1,fi-1];                                    Берем случайное e из промежутка от 1 до fi-1
	mpz_class e;
	e = assign(1,fi-1);
	//----------------

	//d = mul_inv(e,fi);                              d = мультипликативно обратное от e по модулю fi
	mpz_class d;
	d = mul_inv(e,fi);
	//----------------

	//echo "Please type number to encrypt:";          просим пользователя ввести сообщение
	cout << "Please type number to encrypt:" << endl;
	//----------------

	//m = scan(stdin);                                считываем с клавиатуры
	mpz_class m;
	m = scan(stdin);
	//----------------
	
	//c = m^e(mod n);                                 шифруем: с = m в степени e по модулю n
	mpz_class c;
	c = powm(m,e,n);
	//----------------

	//mm = c^d(mod n);                                расшифровываем
	mpz_class mm;
	mm = powm(c,d,n);
	//----------------

	//if (mm == m) echo "Perfect\n";
	if (mm == m) 
	{
#ifdef DEBUG
		cout << "mm = " << mm.get_str() << endl;
		cout << "m  = " << m.get_str() 	<< endl;
#endif
		cout << "Perfect" << endl;
	}
	//----------------
	
	//else echo "Error\n";
	else cout << "Error" << endl;
	//----------------

	return 0;
}

//vim: set noexpandtab:tabstop=4:shiftwidth=4 
