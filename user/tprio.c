#include "types.h"
#include "user.h"

#define PRIO_HIGH 0
#define PRIO_MID 5
#define PRIO_LOW 9

// Función que mantiene la CPU ocupada
void burn_cpu(char *symbol)
{
  int acc = 0;

  for (int i = 0; i < 2500; ++i)
  {
    printf(1, "%s", symbol);

    // Salto de línea cada 64 caracteres para que el patrón visual sea distinto
    if ((i % 64) == 63)
    {
      printf(1, "\n");
    }

    // Bucle pesado para consumir tiempo de procesador
    for (int j = 0; j < 1200000; ++j)
    {
      acc ^= (i + j); // Usamos XOR en lugar de suma para variar la operación
    }
  }

  // Imprime el resultado y confirma su prioridad
  printf(1, "\n\n>>> Proceso [%s] FINALIZADO | Resultado op: %d | Prioridad actual: %d <<<\n\n",
         symbol, acc, getprio(getpid()));
}

int main(int argc, char *argv[])
{
  int pid = fork();

  // El padre original termina para que toda la prueba corra en segundo plano
  if (pid > 0)
  {
    exit(0);
  }

  printf(1, "[Fase 1] Lanzando procesos de prueba.\n");
  printf(1, "Hay 4 procesos ejecutandose: 3 de baja prioridad (9) y 1 normal (5).\n");
  printf(1, "Deberian verse los caracteres intercalados por el Round-Robin.\n");

  // Lanzamos los procesos secuencialmente de forma más limpia
  if (fork() == 0)
  {
    setprio(getpid(), PRIO_LOW);
    burn_cpu(".");
    exit(0);
  }
  if (fork() == 0)
  {
    setprio(getpid(), PRIO_LOW);
    burn_cpu("~");
    exit(0);
  }
  if (fork() == 0)
  {
    setprio(getpid(), PRIO_MID); // Prioridad 5 (competirá con el shell)
    burn_cpu("#");
    exit(0);
  }
  if (fork() == 0)
  {
    setprio(getpid(), PRIO_LOW);
    burn_cpu("@");
    exit(0);
  }

  printf(1, "\n[Fase 2] El proceso despachador duerme 5 segundos (aprox).\n");
  printf(1, "Prueba a interactuar con el shell ahora. Deberia responder bien al tener prioridad 5.\n");

  // 500 ticks equivalen aproximadamente a 5 segundos
  sleep(500);

  printf(1, "\n[Fase 3] Despertando y lanzando 2 procesos de ALTA prioridad (0 y 1).\n");
  printf(1, "Ahora el shell quedara bloqueado hasta que estos dos terminen.\n");
  printf(1, "Luego deberian seguir los de baja prioridad que aun no han terminado.\n");

  if (fork() == 0)
  {
    setprio(getpid(), PRIO_HIGH); // Prioridad 0 (absoluta)
    burn_cpu("!");
    exit(0);
  }
  if (fork() == 0)
  {
    setprio(getpid(), PRIO_HIGH + 1); // Prioridad 1
    burn_cpu("$");
    exit(0);
  }

  // Esperar pacientemente a que todos los hijos terminen antes de salir
  int status;
  while (wait(&status) != -1)
    ;

  printf(1, "\n[Fin] Todos los procesos de la prueba tprio han terminado.\n");
  exit(0);
}