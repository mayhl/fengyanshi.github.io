.. _section-vessel-morpho-compile:

Compile the code for shipwake + sediment case
#############################################

**Makefile**

See an example of a complete "Makefile" :ref:`here <subsection-compile>`.

For this example, you will need to update the :code:`EXEC` variable, and make sure the appriopriate :code:`FLAGS` are active in the "Makefile". You will add the :code:`-DVESSEL` and :code:`-DSEDIMENT` flags:


.. code-block:: rest

   #---------BEGIN MAKEFILE-----------
        ...
        ...
        EXEC   = funwave_vessel      # for example

   #-----------------------------------
   #    PRECISION ...
   #
   #-----------------------------------
   ## FLAGS
   ## Flag numbers are arbitrary, but necessary 

        FLAG_1 = -DDOUBLE_PRECISION
        FLAG_4 = -DCARTESIAN 
        FLAG_12 = -DVESSEL
        FLAG_16 = -DSEDIMENT
   
   # if parallel add
        FLAG_2 = -DPARALLEL

   # if intel compiler add
        FLAG_6 = -DINTEL
        ...

   #----------------------------------
   # mpi defs
   #----------------------------------
   ## COMPILER INFO

        ...

        FC = mpif90     # for example

The compiled exe file is "funwave_vessel.exe".


