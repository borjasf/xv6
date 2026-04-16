struct stat;
struct rtcdate;

// system calls
extern int fork(void);
extern void exit(int) __attribute__((noreturn));
extern int wait(int *);
extern int pipe(int *);
extern int write(int, const void *, int);
extern int read(int, void *, int);
extern int close(int);
extern int kill(int);
extern int exec(char *, char **);
extern int open(const char *, int);
extern int mknod(const char *, short, short);
extern int unlink(const char *);
extern int fstat(int fd, struct stat *);
extern int link(const char *, const char *);
extern int mkdir(const char *);
extern int chdir(const char *);
extern int dup(int);
extern int getpid(void);
extern char *sbrk(int);
extern int sleep(int);
extern int uptime(void);
extern int date(struct rtcdate *);
extern int dup2(int, int);
extern int getprio(int);
extern int setprio(int, int);

// ulib.c
extern int stat(const char *, struct stat *);
extern char *strcpy(char *, const char *);
extern void *memmove(void *, const void *, int);
extern char *strchr(const char *, char c);
extern int strcmp(const char *, const char *);
extern void printf(int, const char *, ...);
extern char *gets(char *, int max);
extern uint strlen(const char *);
extern void *memset(void *, int, uint);
extern void *malloc(uint);
extern void free(void *);
extern int atoi(const char *);

// MACROS PARA ANALIZAR EL ESTADO DE SALIDA DE LOS PROCESOS HIJOS
// Bits bajos (0-7): Guardan información sobre cómo murió el proceso hijo (señal, error)
// Bits altos (8-15): Guardan el número exacto que el hijo puso en su exit(n).

// Mira si los bits bajos están a 0, que indicaría que el proceso hijo terminó voluntariamente.
#define WIFEXITED(status) (((status) & 0x7f) == 0)

// Se queda con la parte alta (0xff00) y la corre 8 bits a la derecha para obtener el número que el hijo puso en exit(n).
#define WEXITSTATUS(status) (((status) & 0xff00) >> 8)

// Mira si los bits bajos son distintos de 0, que indicaría que el proceso hijo terminó por una señal o error.
#define WIFSIGNALED(status) (((status) & 0x7f) != 0)

// Toma los bits bajos (0x7f) y les resta 1 para obtener el número de la señal que causó la muerte del proceso hijo.
// Se resta 1 porque el kernel suma 1 a la señal para diferenciarla de un proceso que terminó voluntariamente (donde los bits bajos serían 0).
#define WEXITTRAP(status) (((status) & 0x7f) - 1)
