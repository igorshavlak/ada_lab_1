with Ada.Text_IO; use Ada.Text_IO;
with Ada.Calendar; use Ada.Calendar;

procedure Main is

   Num_Threads : Integer := 7;
   Sum : Integer := 0;
   Step : Integer := 3;
   Wait_Time : Duration := 3.0;
   Finish_Flag : array (1..Num_Threads) of Boolean := (others => False);
   pragma Atomic(Finish_Flag);
   task type Calculate_Sum is
      entry Start(Thread_ID : Integer; Step : Integer);
   end Calculate_Sum;

   task type Allow_Finish is
      entry Start(Timer : Duration; id : Integer);
   end Allow_Finish;

   task body Calculate_Sum is
      Current_Sum : Integer := 0;
      Step :  Integer;
      Thread_ID : Integer;
      Count : Integer := 0;
   begin
      accept Start(Thread_ID : Integer; Step : Integer) do
         Calculate_Sum.Step := Step;
         Calculate_Sum.Thread_ID := Thread_ID;
      end Start;

      loop
         Current_Sum := Current_Sum + Count * Step;
         Count := Count + 1;
         exit when Finish_Flag(Thread_ID);

      end loop;
      Put_Line("NIGGER");

       Put_Line("Thread " &Integer'Image(Thread_ID) & "Sum " &Integer'Image(Current_Sum) & "Count " &Integer'Image(Count));
   end Calculate_Sum;

   task body Allow_Finish is
      Timer : Duration;
      Id : Integer;
   begin
      accept Start(Timer : in Duration; Id : in Integer) do
         Allow_Finish.Timer := Timer;
         Allow_Finish.Id := Id;
      end Start;

      delay Timer;
      Finish_Flag(Id) := true;
   end Allow_Finish;

   Threads_array : array (1..Num_Threads) of Calculate_Sum;
   Allow_Finish_array : array (1..Num_Threads) of Allow_Finish;

begin
   for i in Threads_array'Range loop
      Threads_array(i).Start(i, 2);
      Allow_Finish_array(i).Start(Wait_Time, i);
   end loop;
end Main;
