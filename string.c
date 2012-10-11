#include <types.h>
#include <defs.h>
//#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  // while there's still stuff to move
  while(n > 0) {
    // if our start is 32b aligned, AND what's left is 4 or more bytes long
    if ((int)dst%4 == 0 && (n >= 4)){
      c &= 0xFF;				// mask the lower 8 bits
      PUT32((uint)dst, (c<<24)|(c<<16)|(c<<8)|c);	// put 4 bytes of those @ pointer
      n-=4;					// tick off 4 done
      dst+=4;					// move the pointer by four
    } else					// otherwise
      PUT8((uint)dst, c);			// only put down 1 byte worth
      n-=1;					// mark it done
      dst+=1;					// move the pointer
  }
  return dst;					// return the pointer, pointing just beyond the end
}

int
memcmp(const void *v1, const void *v2, uint n)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}

void*
memmove(void *dst, const void *src, uint n)
{
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  char *os;
  
  os = s;
  if(n <= 0)
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    ;
  *s = 0;
  return os;
}

int
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    ;
  return n;
}

