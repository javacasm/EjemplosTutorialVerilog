<img src="https://github.com/javacasm/EjemplosTutorialVerilog/blob/master/icezum/T01-setbit/images/Icezum_T01.png?raw=true" width="400" align="center">

[Ejemplos de este capítulo en github](https://github.com/javacasm/EjemplosTutorialVerilog/tree/master/icezum/T01-setbit)

## Antes de empezar

**No olvides clonar los tutoriales** en tu ordenador, para tener acceso a todos los programas de ejemplo:

```
https://github.com/javacasm/EjemplosTutorialVerilog.git
```

**Entra en el directorio de trabajo** del tutorial 1:

```
cd icezum/T01-setbit/
```

¡Estás listo para hacer el tutorial!

## Introducción

El **circuito digital** más sencillo es simplemente **un cable** que está conectado a un **nivel lógico** conocido, por ejemplo 1. De esta forma al conectar un led se iluminará (1) o se apagará (0)

![Imagen 1](https://github.com/Obijuan/open-fpga-verilog-tutorial/raw/master/tutorial/ICESTICK/T01-setbit/images/setbit-1.png)

La salida de este circuito la hemos denominado A.

## setbit.v: Descripción del hardware

Para sintetizar este circuito en la FPGA, primero lo tenemos que describir usando un **lenguaje de descripción hardware** (HDL). En este tutorial utilizaremos **Verilog**, ya que tenemos todas las herramientas libres para su simulación / síntesis.

Verilog es un lenguaje que sirve para describir hardware... pero ¡Cuidado! **¡NO ES UN LENGUAJE DE PROGRAMACIÓN!** ¡Es un lenguaje de descripción! Nos permite describir las conexiones y los elementos de un sistema digital.

El código verilog que implementa este circuito "hola mundo" se encuentra en el fichero [setbit.v](./T01-setbit/setbit.v). Tiene esta pinta:

```verilog
//-- Fichero setbit.v
`default_nettype none

module setbit(output A);
wire A;

assign A = 1;

endmodule
```

## Síntesis en la FPGA

Además del fichero en verilog del componente, necesitamos indicar a qué **pin** de la FPGA queremos **conectar la salida A** de nuestro componente. Este mapeo se realiza en el fichero **icezum.pcf** (pcf = Physical Constraint file). Lo sacaremos por el pin 95 que se corresponde con el **led D0** de la placa ICEZum. Pero podría ser cualquier otro. Añadimos al fichero **icezum.pcf** la siguiente línea:

    set_io A 95

En esta línea **se asocia la etiqueta A** del componente **al pin 95** de la FPGA. Puedes ver que hay muchas otras asociaciones en el fichero para facilitarnos la tarea de usar directamente los pines de la IceZum Alhambra

En la figura 2 se muestra gráficamente esta idea.  Como lo que estamos describiendo es hardware, siempre es interesante **hacerse esquemas y dibujos** para comprenderlo mejor:

![Imagen 2](https://github.com/Obijuan/open-fpga-verilog-tutorial/raw/master/tutorial/ICESTICK/T01-setbit/images/setbit-2.png)

Para hacer la síntesis completa nos vamos al directorio _tutorial/T01-setbit_ y ejecutamos el comando **apio build** desde la consola:

    $ apio build


Saldrán muchos más mensajes. En mi portátil tarda en sintetizar **menos de 1 segundo**. Los mensajes finales que se obtienen son:

    ...
    After placement:
    PIOs       1 / 96
    PLBs       1 / 160
    BRAMs      0 / 16


    place time 0.00s
    route...
    pass 1, 0 shared.

    After routing:
    span_4     0 / 6944
    span_12    0 / 1440

    route time 0.00s
    write_txt hardware.asc...

Al terminar se habrá generado el fichero **hardware.bin** que es el que cargaremos en la FPGA para configurarla. Introducimos la iCEZum en el USB y ejecutamos este comando:

    $ apio upload


El proceso dura aproximadamente **2 segundos**. Los mensajes que aparecen son:

    Info: use apio.ini board: icezum
    Number of FTDI devices found: 1
    Checking device: 0
    Manufacturer: Mareldem, Description: IceZUM Alhambra v1.1 - B01-021

    Using default SConstruct file
    [Sun Dec  4 00:53:01 2016] Processing icezum
    --------------------------------------------------------------------------------------------------------------------------------------------------------------
    FPGA_SIZE: 1k
    FPGA_TYPE: hx
    FPGA_PACK: tq144
    PROG: iceprog -d i:0x0403:0x6010:%DEVICE
    DEVICE: 0
    iceprog -d i:0x0403:0x6010:0 hardware.bin
    init..
    cdone: high
    reset..
    cdone: low
    flash ID: 0x20 0xBA 0x16 0x10 0x00 0x00 0x23 0x54 0x82 0x46 0x06 0x00 0x51 0x00 0x25 0x19 0x01 0x16 0x9B 0x50
    file size: 32220
    erase 64kB sector at 0x000000..
    programming..
    reading..
    VERIFY OK
    cdone: high
    Bye.


El **led D1** de la ICEZum **se encenderá**:

TODO: cambiar foto

<img src="https://github.com/javacasm/EjemplosTutorialVerilog/blob/master/icezum/T01-setbit/images/Icezum_T01.png?raw=true" width="400" align="center">

**Nota:** Puede que los otros LED se enciendan parcialmente; esto es normal y debido a que no les hemos asignado ninguna señal (internamente están conectados "al aire").

## Simulación

### Primero simulamos, luego sintetizamos

El ejemplo anterior lo hemos cargado directamente en la FPGA porque el diseño ya **ESTABA PROBADO PREVIAMENTE**. Cuando trabajamos con FPGAs **estamos haciendo hardware** y tenemos que tener siempre mucho cuidado. Podemos escribir un código que por ejemplo tenga un cortocircuito. Y podría ocurrir que las herramientas de síntesis no nos avisen con un **warning** (sobre todo con estas primeras versiones que todavía están en estado alfa). Si lo cargamos en la FPGA la podríamos estropear parcialmente.

Por ello, **SIEMPRE** hay que **simular el código** que hagamos. Y una vez que estamos lo bastante seguros de que funciona (o que no tiene error gordos) es cuando lo cargamos en la FPGA.

### Probando componentes: banco de trabajo

Si compramos un chip y lo queremos probar, ¿Qué hacemos?. Hombre, normalmente lo soldamos directamente en el PCB o lo introducimos en un zócalo.  Pero también lo podemos pinchar en una placa entrendora y colocar nosotros los cables de conexión a la alimentación, señales y resto de componentes.

En verilog (y resto de lenguajes HDL) hacemos lo mismo.  Un componente descrito en Verilog (como por ejemplo setbit.v) **no se puede simular directamente**. Es necesario escribir un **banco de pruebas** que indique qué cables conectar a sus pines, qué valores de prueba enviar y comprobar que por sus salidas salen resultados correctos. Este banco de pruebas es un fichero también en Verilog.

¿Cómo comprobamos el componente setbit? Se trata de un chip que sólo tiene **un pin de salida** que siempre está a '1'. En la vida real lo pondríamos en su placa de puntos, lo alimentaríamos, conectaríamos un cable en su pin de salida (A) y usando un polímetro comprobaríamos que sale una tensión igual a la de alimentación (un '1').  Haremos exactamente eso, pero describiéndolo en Verilog. Gráficamente tendríamos lo siguiente:

![Imagen 3](https://github.com/Obijuan/open-fpga-verilog-tutorial/raw/master/tutorial/ICESTICK/T01-setbit/images/setbit-3.png)

El fichero se llama **setbit_tb.v**. Siempre usaremos el **sufijo _tb** para indicar que se trata de un **banco de pruebas** (TestBench) y ¡No de hardware real!. Este banco de pruebas **NO ES SINTETIZABLE**. Es un código que **sólo vale para la SIMULACIÓN**.  Lo que sintetizamos es el componente setbit.v.  Por eso, a la hora de hacer bancos de pruebas, estamos empleando Verilog no como una herramienta de descripción hardware sino como un programa. Aquí **sí podemos pensar en Verilog como un lenguaje de programación tradicional**.

El banco de pruebas tiene 3 elementos: el componente setbit, un cable que hemos llamado A y **un bloque de comprobación** (que sería el equivalente al polímetro en el mundo real). El código es el siguiente:

```verilog
//------------------------------------------------------------------
//-- Verilog template
//-- Test-bench entity
//-- Board: icezum
//------------------------------------------------------------------

`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module setbit_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 10;

//-- Clock signal. It is not used in this simulation
reg clk = 0;
always #0.5 clk = ~clk;

//-- Led port
wire A;

//-- Instantiation of the unit to test

setbit SB1(
  .A (A)
  );


initial begin

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, setbit_tb);





   #(DURATION)  if (A != 1)
                  $display("Error!!!");
                else
                  $display("End of simulation");
  $finish;
end

endmodule
```

## ¡Simulando!

Para simular utilizamos las herramientas **Icarus Verilog** y **GTKwave**. Ejecutamos el comando:

    $ apio sim

y automáticamente se nos abrirá una ventana con el resultado de la simulación:

<img src="https://github.com/Obijuan/open-fpga-verilog-tutorial/raw/master/tutorial/ICESTICK/T01-setbit/images/T01-setbit-simul-1.png" width="600" align="center">

A un golpe de vista comprobamos que se comporta como esperábamos: la señal del cable A está siempre a '1'. Ignoramos las unidades de tiempo que pone, que por defecto está en segundos. Para nosotros serán unidades de tiempo. Tras 20 unidades, la simulación termina.

En la consola veremos que han aparecido los siguientes mensajes:
```
Using default SConstruct file
iverilog -B .../ivl -o setbit_tb.out -D VCD_OUTPUT=setbit_tb .../vlib/system.v setbit.v setbit_tb.v
vvp -M .../lib/ivl setbit_tb.out
VCD info: dumpfile setbit_tb.vcd opened for output.
End of simulation
gtkwave setbit_tb.vcd setbit_tb.gtkw

GTKWave Analyzer v3.3.66 (w)1999-2015 BSI

[0] start time.
[1000] end time.

```

El que pone "**Componente ok!**" es el que hemos puesto nosotros en el banco de pruebas cuando la salida estaba a '1'

## Ejercicios propuestos

* Cambiar el componente para que saque un 0. Descargarlo en la FPGA. Comprobar que el LED está ahora apagado

* Cambiar el ejemplo original para que se encienda el LED D2 en vez el D1  (está asociado al pin 98 en vez de al 99)

## Conclusiones
Hemos creado **nuestro primer circuito en verilog**, un "hola mundo" formado por **1 cable**. Lo hemos sintetizado y cargado en la FPGA. También hemos **programado** un **banco de pruebas** en verilog para simularlo.  Ya tenemos todas las herramientas instaladas, configuradas y hemos comprobado que funcionan. Estamos listos para abordar diseños más complejos e ir aprendiendo más verilog

### Conceptos introducidos:
* Conexión de cables son **assign**
* Creación de componentes con **module**
* Definición de puertos de salida con **output**
* Definición de un cable con **wire**
* Banco de pruebas
