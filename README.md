# CS202
### 评分说明

---

+ 评分以代码规范（结构化设计、变量命名、代码规范、注释）、文档、功能验收演示为准。 
+ 包括基本分（100分：基本功能 + 文档 + 代码规范）和bonus（30分）两部分，如得分超过100，则溢出 的部分将按比例计入总评 
+ 基本功能： 
  - 1）覆盖到所支持的ISA中的全部指令 
  - 2）使用外设的种类数>2 
  - 3） 测试通过基本场景1、基本场景2 
+ bonus 包括但不限于： 
  - 1）实现对复杂外设接口的支持（如VGA接口、小键盘接口） 
  - 2）使用uart接口实现不重新烧写FPGA芯片的前提下加载不同的程序到CPU上做执行 
  - 3）基于现有 ISA Minisys 实现的CPU，在CPU的功能或性能上实现的优化 
  - 4）针对现有Minisys 的ISA，做的指令类型扩展、功能扩展和实现 
+ 补充：实现其他类型的ISA（如RISC-V，MIPS32）将按照以上要求进行检查，根据完成情况在总分基础 上乘以1.1~1.3的系数（该情况下，不重复考虑bonus的3、4部分）。

---

### 测试场景
#### 基本测试场景一
<img src ="https://user-images.githubusercontent.com/95575156/172392585-6ae64d9c-44d1-4e0c-b6a2-ec988132b4cd.png" style="zoom: 30%">

#### 基本测试场景二
+ 1/2
  - <img src ="https://user-images.githubusercontent.com/95575156/172392736-5701bc00-9de1-417a-bd17-bae174b90fe8.png" style="zoom: 30%">

+ 2/2
  - <img src ="https://user-images.githubusercontent.com/95575156/172392811-68fb8d5a-a6d9-4dd0-92fc-9b3213a6b345.png" style="zoom: 30%">

