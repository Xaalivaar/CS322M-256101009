# Report
<hr>
<hr>

### Aim: To  implement a pipelined RISC-V processor with additional custom RVX-10 instructions

##### Following is the target microarchitecture.
![alt text](image-66.png)
<hr>

### Measures for debugging
The following line of code was added in the testbench to
see what is being stored where.
```
                    $display("%d %d", DataAdr, WriteData);
```
<hr>

### Test cases
- Screenshots are in order - Fetch, Decode(2), Execute, MemWrite, Writeback
<hr>

<b> rv32I </b><br>

![alt text](image.png)
![alt text](image-1.png)
![alt text](image-2.png)
![alt text](image-3.png)
![alt text](image-4.png)
<hr>

<b>andn</b>  <br>

![alt text](image-5.png)
![alt text](image-6.png)
![alt text](image-7.png)
![alt text](image-8.png)
![alt text](image-9.png)
![alt text](image-10.png)
<hr>

<b>maxu</b>  <br>

![alt text](image-11.png)
![alt text](image-12.png)
![alt text](image-13.png)
![alt text](image-14.png)
![alt text](image-15.png)
![alt text](image-16.png)
<hr>

<b> minu  </b><br>

![alt text](image-17.png)
![alt text](image-18.png)
![alt text](image-19.png)
![alt text](image-20.png)
![alt text](image-21.png)
![alt text](image-22.png)
<hr>

<b> ror    </b><br>

![alt text](image-23.png)
![alt text](image-24.png)
![alt text](image-25.png)
![alt text](image-26.png)
![alt text](image-27.png)
![alt text](image-28.png)
<hr>

<b> abs </b><br>

![alt text](image-29.png)
![alt text](image-30.png)
![alt text](image-31.png)
![alt text](image-32.png)
![alt text](image-33.png)
![alt text](image-34.png)
<hr>

<b> max   </b><br>

![alt text](image-47.png)
![alt text](image-36.png)
![alt text](image-38.png)
![alt text](image-37.png)
![alt text](image-39.png)
![alt text](image-40.png)
<hr>

<b>min</b><br>

![alt text](image-41.png)
![alt text](image-42.png)
![alt text](image-43.png)
![alt text](image-44.png)
![alt text](image-45.png)
![alt text](image-46.png)
<hr>

<b> orn   </b><br>

![alt text](image-48.png)
![alt text](image-49.png)
![alt text](image-50.png)
![alt text](image-51.png)
![alt text](image-52.png)
![alt text](image-53.png)
<hr>

<b> rol </b><br>

![alt text](image-54.png)
![alt text](image-56.png)
![alt text](image-55.png)
![alt text](image-57.png)
![alt text](image-58.png)
![alt text](image-59.png)
<hr>

<b> xnor </b><br>

![alt text](image-60.png)
![alt text](image-62.png)
![alt text](image-61.png)
![alt text](image-63.png)
![alt text](image-64.png)
![alt text](image-65.png)
<hr>
