## Descripción
Componente "hola mundo" con un pin de salida que siempre está a '1'.
Al cargarlo en la iCEZum se enciende el led LED0

## Simulación

Para realizar la simulacion entrar en el directorio y ejecutar:

    $ apio sim

Automaticamente se invocará al icarus verilog para hacer la compilacion / simulación y al gtkwave para ver el resultado de la simulacion gráficamente

## Síntesis

Para implementar el diseño en la FPGA ejecutamos el comando:

    $ apio build

Se nos genera el fichero setbit.bin que contiene la conguración de la FPGA para que se nos implemente nuestro circuito digital.

Lo descargamos en la fpga mediante el comando:

    $ apio upload
