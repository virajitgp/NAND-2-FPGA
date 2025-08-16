import tkinter as tk
from tkinter import ttk, scrolledtext, messagebox, filedialog
import re
import struct


class CPU:
    """
    Simulates the 16-bit CPU, including registers, memory, and flags.
    Executes machine code based on the defined ISA.
    """

    def __init__(self, screen_update_callback=None):
        self.screen_update_callback = screen_update_callback
        self.reset()

    def reset(self):
        """Resets all CPU components to their initial state."""
        self.registers = [0] * 16
        self.memory = [0] * 65536
        self.pc = 0  # Program Counter
        self.flags = {"Z": 0, "C": 0, "O": 0}
        self.halted = False
        self.VIDEO_RAM_START = 0x8000
        self.KEYBOARD_BUFFER = 0xC000

    def load_program(self, machine_code):
        """Loads machine code into memory starting at address 0."""
        self.reset()
        for i, instruction in enumerate(machine_code):
            if i < len(self.memory):
                self.memory[i] = instruction

    def set_key_press(self, key_code):
        """Simulates a key press by writing to the keyboard buffer."""
        self.memory[self.KEYBOARD_BUFFER] = key_code

    def step(self):
        """Fetches, decodes, and executes a single instruction."""
        if self.halted:
            return
        instruction = self.fetch()
        if instruction is None:
            self.halted = True
            return
        self.pc += 1
        self.decode_and_execute(instruction)
        if self.memory[self.KEYBOARD_BUFFER] != 0:
            pass

    def fetch(self):
        """Fetches the instruction at the current PC."""
        if self.pc >= len(self.memory):
            return None
        return self.memory[self.pc]

    def _update_flags(self, result, carry=None, overflow=None):
        """Updates flags based on the result of an operation."""
        self.flags["Z"] = 1 if (result & 0xFFFF) == 0 else 0
        if carry is not None:
            self.flags["C"] = carry
        if overflow is not None:
            self.flags["O"] = overflow

    def decode_and_execute(self, instruction):
        """Decodes and executes a single 16-bit instruction."""
        try:
            opcode = (instruction >> 12) & 0b1111
            rd = (instruction >> 8) & 0b1111
            ra = (instruction >> 4) & 0b1111
            rb = instruction & 0b1111
            imm = instruction & 0b1111
            j_addr = instruction & 0b0000111111111111

            val_a = self.registers[ra]
            val_b = self.registers[rb]

            if opcode == 0x0:  # ADD
                res_32 = val_a + val_b
                res_16 = res_32 & 0xFFFF
                self.registers[rd] = res_16
                carry = 1 if res_32 > 0xFFFF else 0
                overflow = (
                    1
                    if (val_a >> 15) == (val_b >> 15)
                    and (res_16 >> 15) != (val_a >> 15)
                    else 0
                )
                self._update_flags(res_16, carry, overflow)

            elif opcode == 0x1:  # SUB
                res_32 = val_a - val_b
                res_16 = res_32 & 0xFFFF
                self.registers[rd] = res_16
                carry = 1 if val_a < val_b else 0
                overflow = (
                    1
                    if (val_a >> 15) != (val_b >> 15)
                    and (res_16 >> 15) != (val_a >> 15)
                    else 0
                )
                self._update_flags(res_16, carry, overflow)

            elif opcode == 0x2:  # AND
                res_16 = val_a & val_b
                self.registers[rd] = res_16
                self._update_flags(res_16)

            elif opcode == 0x3:  # OR
                res_16 = val_a | val_b
                self.registers[rd] = res_16
                self._update_flags(res_16)

            elif opcode == 0x4:  # XOR
                res_16 = val_a ^ val_b
                self.registers[rd] = res_16
                self._update_flags(res_16)

            elif opcode == 0x5:  # NOT
                res_16 = ~val_a & 0xFFFF
                self.registers[rd] = res_16
                self._update_flags(res_16)

            elif opcode == 0x6:  # SHL
                shift_amount = val_b & 0b1111
                res_16 = (val_a << shift_amount) & 0xFFFF
                self.registers[rd] = res_16
                carry = (val_a >> (16 - shift_amount)) & 1 if shift_amount > 0 else 0
                self._update_flags(res_16, carry=carry)

            elif opcode == 0x7:  # SHR
                shift_amount = val_b & 0b1111
                res_16 = (val_a >> shift_amount) & 0xFFFF
                self.registers[rd] = res_16
                carry = (val_a >> (shift_amount - 1)) & 1 if shift_amount > 0 else 0
                self._update_flags(res_16, carry=carry)

            elif opcode == 0x8:  # LDI
                val_imm = imm
                if (val_imm >> 3) & 1:
                    val_imm |= 0xFFF0
                self.registers[rd] = val_imm & 0xFFFF
                self._update_flags(self.registers[rd])

            elif opcode == 0x9:  # ADDI
                val_imm = imm
                if (val_imm >> 3) & 1:
                    val_imm |= 0xFFF0
                res_32 = val_a + val_imm
                res_16 = res_32 & 0xFFFF
                self.registers[rd] = res_16
                carry = 1 if res_32 > 0xFFFF else 0
                overflow = (
                    1
                    if (val_a >> 15) == (val_imm >> 15)
                    and (res_16 >> 15) != (val_a >> 15)
                    else 0
                )
                self._update_flags(res_16, carry, overflow)

            elif opcode == 0xA:  # LOAD
                addr = (self.registers[ra] + imm) & 0xFFFF
                self.registers[rd] = self.memory[addr]

            elif opcode == 0xB:  # STORE
                addr = (self.registers[ra] + imm) & 0xFFFF
                self.memory[addr] = self.registers[rd]
                if self.VIDEO_RAM_START <= addr < self.KEYBOARD_BUFFER:
                    if self.screen_update_callback:
                        self.screen_update_callback(addr, self.registers[rd])

            elif opcode == 0xC:  # CMPEQ
                res_16 = 1 if val_a == val_b else 0
                self.registers[rd] = res_16
                self.flags["Z"] = 1 if val_a == val_b else 0

            elif opcode == 0xD:  # CMPLT
                s_val_a = val_a if val_a < 32768 else val_a - 65536
                s_val_b = val_b if val_b < 32768 else val_b - 65536
                res_16 = 1 if s_val_a < s_val_b else 0
                self.registers[rd] = res_16
                self._update_flags(res_16)

            elif opcode == 0xE:  # JMP
                self.pc = j_addr

            elif opcode == 0xF:  # BZ
                if self.flags["Z"] == 1:
                    self.pc = j_addr

        except IndexError:
            messagebox.showerror(
                "Runtime Error", f"Memory access violation at address: {self.pc-1}"
            )
            self.halted = True
        except Exception as e:
            messagebox.showerror("Runtime Error", f"An unexpected error occurred: {e}")
            self.halted = True


class Assembler:
    """
    A two-pass assembler for the custom 16-bit ISA.
    """

    def __init__(self):
        self.opcodes = {
            "ADD": (0x0, "R"),
            "SUB": (0x1, "R"),
            "AND": (0x2, "R"),
            "OR": (0x3, "R"),
            "XOR": (0x4, "R"),
            "NOT": (0x5, "R"),
            "SHL": (0x6, "R"),
            "SHR": (0x7, "R"),
            "LDI": (0x8, "I"),
            "ADDI": (0x9, "I"),
            "LOAD": (0xA, "I"),
            "STORE": (0xB, "I"),
            "CMPEQ": (0xC, "R"),
            "CMPLT": (0xD, "R"),
            "JMP": (0xE, "J"),
            "BZ": (0xF, "J"),
        }
        self.symbol_table = {}

    def assemble(self, code):
        """Assembles the provided code string."""
        self.symbol_table = {}
        lines = [
            line.strip()
            for line in code.split("\n")
            if line.strip() and not line.strip().startswith(";")
        ]

        address = 0
        cleaned_lines = []
        for line in lines:
            line = re.sub(r";.*$", "", line).strip()
            if not line:
                continue

            match = re.match(r"^([a-zA-Z_][a-zA-Z0-9_]*):$", line)
            if match:
                self.symbol_table[match.group(1).upper()] = address
            else:
                cleaned_lines.append(line)
                address += 1

        machine_code = []
        for line in cleaned_lines:
            parts = re.split(r"[,\s]+", line, maxsplit=1)
            mnemonic = parts[0].upper()
            operands_str = parts[1] if len(parts) > 1 else ""
            operands = (
                [op.strip().upper() for op in operands_str.split(",")]
                if operands_str
                else []
            )

            if mnemonic not in self.opcodes:
                raise ValueError(f"Unknown instruction: {mnemonic}")

            opcode, op_type = self.opcodes[mnemonic]
            instruction = opcode << 12

            if op_type == "R":
                rd = int(operands[0][1:])
                ra = int(operands[1][1:])
                rb = 0
                if len(operands) > 2:
                    rb = int(operands[2][1:])
                instruction |= (rd << 8) | (ra << 4) | rb

            elif op_type == "I":
                rd = int(operands[0][1:])
                ra = 0
                imm = 0
                if "LDI" in mnemonic:
                    imm = self.parse_immediate(operands[1])
                else:
                    ra = int(operands[1][1:])
                    imm = self.parse_immediate(operands[2])
                instruction |= (rd << 8) | (ra << 4) | (imm & 0xF)

            elif op_type == "J":
                label = operands[0]
                if label in self.symbol_table:
                    addr = self.symbol_table[label]
                else:
                    addr = self.parse_immediate(label)
                instruction |= addr & 0xFFF

            machine_code.append(instruction)
        return machine_code

    def parse_immediate(self, val_str):
        """Parses an immediate value which can be decimal, hex, or binary."""
        val_str = val_str.lower()
        if val_str.startswith("0x"):
            return int(val_str, 16)
        if val_str.startswith("0b"):
            return int(val_str, 2)
        return int(val_str)


class SimulatorGUI(tk.Tk):
    """
    The main GUI for the simulator, built with tkinter.
    """

    def __init__(self):
        super().__init__()
        self.title("16-bit CPU Simulator")
        self.geometry("1200x850")
        self.configure(bg="#2E2E2E")

        self.style = ttk.Style(self)
        self.style.theme_use("clam")
        self.style.configure(
            ".",
            background="#2E2E2E",
            foreground="#DCDCDC",
            fieldbackground="#3C3C3C",
            bordercolor="#555",
        )
        self.style.configure(
            "TButton",
            padding=6,
            relief="flat",
            background="#555555",
            foreground="#FFFFFF",
        )
        self.style.map("TButton", background=[("active", "#6A6A6A")])
        self.style.configure("TLabel", padding=3)
        self.style.configure("Treeview", rowheight=25)
        self.style.configure(
            "Treeview.Heading", background="#4A4A4A", font=("Consolas", 10, "bold")
        )
        self.style.map("Treeview.Heading", background=[("active", "#5A5A5A")])
        self.style.configure(
            "TNotebook.Tab", padding=[12, 5], font=("Segoe UI", 10, "bold")
        )
        self.style.map(
            "TNotebook.Tab",
            background=[("selected", "#5A5A5A")],
            foreground=[("selected", "white")],
        )

        self.cpu = CPU(self.update_pixel)
        self.assembler = Assembler()
        self.running = False
        self.run_speed = 50

        # --- Main Layout with Tabs ---
        self.notebook = ttk.Notebook(self)
        self.notebook.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

        self.simulator_tab = ttk.Frame(self.notebook, padding=5)
        self.isa_tab = ttk.Frame(self.notebook, padding=5)

        self.notebook.add(self.simulator_tab, text="Simulator")
        self.notebook.add(self.isa_tab, text="ISA Reference")

        self.setup_simulator_tab()
        self.setup_isa_tab()

        self.reset_all()

    def setup_simulator_tab(self):
        """Sets up the main simulator interface inside a tab."""
        main_pane = ttk.PanedWindow(self.simulator_tab, orient=tk.HORIZONTAL)
        main_pane.pack(fill=tk.BOTH, expand=True)

        left_frame = ttk.Frame(main_pane, padding=5)
        right_frame = ttk.Frame(main_pane, padding=5)
        main_pane.add(left_frame, weight=1)
        main_pane.add(right_frame, weight=1)

        self.setup_left_panel(left_frame)
        self.setup_right_panel(right_frame)

    def setup_left_panel(self, parent_frame):
        """Sets up the code editor and control buttons."""
        parent_frame.rowconfigure(1, weight=1)
        parent_frame.columnconfigure(0, weight=1)

        controls_frame = ttk.Frame(parent_frame)
        controls_frame.grid(row=0, column=0, sticky="ew", pady=(0, 10))

        ttk.Button(controls_frame, text="Assemble", command=self.assemble_code).pack(
            side=tk.LEFT, padx=5
        )
        ttk.Button(controls_frame, text="Run", command=self.run_program).pack(
            side=tk.LEFT, padx=5
        )
        ttk.Button(controls_frame, text="Stop", command=self.stop_program).pack(
            side=tk.LEFT, padx=5
        )
        ttk.Button(controls_frame, text="Step", command=self.step_program).pack(
            side=tk.LEFT, padx=5
        )
        ttk.Button(controls_frame, text="Reset", command=self.reset_all).pack(
            side=tk.LEFT, padx=5
        )
        ttk.Button(controls_frame, text="Export HEX", command=self.export_hex).pack(
            side=tk.LEFT, padx=5
        )
        ttk.Button(controls_frame, text="Export BIN", command=self.export_bin).pack(
            side=tk.LEFT, padx=5
        )

        self.code_editor = scrolledtext.ScrolledText(
            parent_frame,
            wrap=tk.WORD,
            undo=True,
            font=("Consolas", 12),
            bg="#1E1E1E",
            fg="#D4D4D4",
            insertbackground="white",
            selectbackground="#264F78",
        )
        self.code_editor.grid(row=1, column=0, sticky="nsew")

    def setup_right_panel(self, parent_frame):
        """Sets up the registers, flags, memory, and screen displays."""
        right_pane = ttk.PanedWindow(parent_frame, orient=tk.VERTICAL)
        right_pane.pack(fill=tk.BOTH, expand=True)

        top_right_frame = ttk.Frame(right_pane)
        memory_frame = ttk.Frame(right_pane)
        screen_frame = ttk.Frame(right_pane, padding=5)

        right_pane.add(top_right_frame, weight=1)
        right_pane.add(memory_frame, weight=2)
        right_pane.add(screen_frame, weight=2)

        self.reg_labels = {}
        reg_frame = ttk.LabelFrame(top_right_frame, text="Registers")
        reg_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5)
        for i in range(16):
            ttk.Label(reg_frame, text=f"R{i}:", font=("Consolas", 10, "bold")).grid(
                row=i % 8, column=(i // 8) * 2, sticky="w", padx=5
            )
            self.reg_labels[i] = ttk.Label(
                reg_frame, text="0x0000 (0)", font=("Consolas", 10)
            )
            self.reg_labels[i].grid(
                row=i % 8, column=(i // 8) * 2 + 1, sticky="w", padx=5
            )

        self.flag_labels = {}
        flag_frame = ttk.LabelFrame(top_right_frame, text="Flags & PC")
        flag_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5)
        flags = ["Z", "C", "O"]
        for i, flag in enumerate(flags):
            ttk.Label(flag_frame, text=f"{flag}:", font=("Consolas", 10, "bold")).grid(
                row=i, column=0, sticky="w"
            )
            self.flag_labels[flag] = ttk.Label(
                flag_frame, text="0", font=("Consolas", 10)
            )
            self.flag_labels[flag].grid(row=i, column=1, sticky="w")
        ttk.Label(flag_frame, text="PC:", font=("Consolas", 10, "bold")).grid(
            row=3, column=0, sticky="w"
        )
        self.pc_label = ttk.Label(flag_frame, text="0x0000 (0)", font=("Consolas", 10))
        self.pc_label.grid(row=3, column=1, sticky="w")

        memory_frame.columnconfigure(0, weight=1)
        memory_frame.rowconfigure(0, weight=1)
        self.memory_view = ttk.Treeview(
            memory_frame, columns=("Address", "Hex", "Decimal"), show="headings"
        )
        self.memory_view.heading("Address", text="Address")
        self.memory_view.heading("Hex", text="Hex Value")
        self.memory_view.heading("Decimal", text="Decimal")
        self.memory_view.column("Address", width=80, anchor="center")
        self.memory_view.column("Hex", width=100, anchor="center")
        self.memory_view.column("Decimal", width=100, anchor="center")
        self.memory_view.grid(row=0, column=0, sticky="nsew")

        screen_frame.configure(style="TFrame")
        self.screen_canvas = tk.Canvas(
            screen_frame, bg="black", width=256, height=256, highlightthickness=0
        )
        self.screen_canvas.pack(pady=5)
        self.screen_pixels = {}
        self.screen_dim = 128
        pixel_size = 256 / self.screen_dim
        for y in range(self.screen_dim):
            for x in range(self.screen_dim):
                addr = self.cpu.VIDEO_RAM_START + (y * self.screen_dim) + x
                px_id = self.screen_canvas.create_rectangle(
                    x * pixel_size,
                    y * pixel_size,
                    (x + 1) * pixel_size,
                    (y + 1) * pixel_size,
                    fill="black",
                    outline="",
                )
                self.screen_pixels[addr] = px_id

    def setup_isa_tab(self):
        """Sets up the ISA reference tab."""
        isa_text_widget = scrolledtext.ScrolledText(
            self.isa_tab,
            wrap=tk.WORD,
            font=("Consolas", 11),
            bg="#1E1E1E",
            fg="#D4D4D4",
        )
        isa_text_widget.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        isa_doc = """
### CPU Core ###
- Architecture: 16-bit RISC
- Word Size: 16 bits
- Address Space: 16 bits (65,536 locations)
- Registers: 16 general-purpose 16-bit registers (R0 through R15)

--------------------------------------------------

### Memory Map ###
- 0x0000 - 0x7FFF: RAM (32K words)
- 0x8000 - 0xBFFF: Video RAM (16K words, for a 128x128 screen)
- 0xC000: Keyboard Buffer (Read-only)
- 0xC001 - 0xFFFF: Reserved

--------------------------------------------------

### Instruction Set ###

#### Arithmetic & Logical ####
- ADD Rd, Ra, Rb:   Rd = Ra + Rb
- SUB Rd, Ra, Rb:   Rd = Ra - Rb
- AND Rd, Ra, Rb:   Rd = Ra & Rb
- OR Rd, Ra, Rb:    Rd = Ra | Rb
- XOR Rd, Ra, Rb:   Rd = Ra ^ Rb
- NOT Rd, Ra:       Rd = ~Ra
- SHL Rd, Ra, Rb:   Rd = Ra << Rb[3:0] (Shift Left)
- SHR Rd, Ra, Rb:   Rd = Ra >> Rb[3:0] (Shift Right)

#### Immediate Operations ####
- LDI Rd, imm:      Rd = imm (Load 4-bit Immediate)
- ADDI Rd, Ra, imm: Rd = Ra + imm (Add 4-bit Immediate)

#### Memory Operations ####
- LOAD Rd, Ra, offset: Rd = Memory[Ra + offset]
- STORE Rd, Ra, offset: Memory[Ra + offset] = Rd

#### Compare Operations ####
- CMPEQ Rd, Ra, Rb: Rd = (Ra == Rb) ? 1 : 0
- CMPLT Rd, Ra, Rb: Rd = (signed(Ra) < signed(Rb)) ? 1 : 0

#### Control Flow ####
- JMP address:      PC = address (Unconditional Jump)
- BZ address:       if (Zero_Flag == 1) PC = address
"""
        isa_text_widget.insert(tk.END, isa_doc)
        isa_text_widget.config(state=tk.DISABLED)  # Make it read-only

    def assemble_code(self):
        self.stop_program()
        try:
            code = self.code_editor.get("1.0", tk.END)
            machine_code = self.assembler.assemble(code)
            self.cpu.load_program(machine_code)
            self.update_all_displays()
            messagebox.showinfo(
                "Assembler", f"Assembled {len(machine_code)} instructions successfully."
            )
        except Exception as e:
            messagebox.showerror("Assembler Error", str(e))

    def export_hex(self):
        """Assembles the code and saves it to a Verilog-compatible .hex file."""
        try:
            code = self.code_editor.get("1.0", tk.END)
            machine_code = self.assembler.assemble(code)

            filepath = filedialog.asksaveasfilename(
                defaultextension=".hex",
                filetypes=[("Hex Files", "*.hex"), ("All Files", "*.*")],
            )
            if not filepath:
                return

            with open(filepath, "w") as f:
                for instruction in machine_code:
                    f.write(f"{instruction:04X}\n")

            messagebox.showinfo(
                "Export Success",
                f"Successfully exported {len(machine_code)} instructions to {filepath}",
            )
        except Exception as e:
            messagebox.showerror("Export Error", f"Could not export file: {e}")

    def export_bin(self):
        """Assembles the code and saves it to a raw binary .bin file."""
        try:
            code = self.code_editor.get("1.0", tk.END)
            machine_code = self.assembler.assemble(code)

            filepath = filedialog.asksaveasfilename(
                defaultextension=".bin",
                filetypes=[("Binary Files", "*.bin"), ("All Files", "*.*")],
            )
            if not filepath:
                return

            with open(filepath, "wb") as f:
                for instruction in machine_code:
                    # Pack as big-endian unsigned short (16 bits)
                    f.write(struct.pack(">H", instruction))

            messagebox.showinfo(
                "Export Success",
                f"Successfully exported {len(machine_code)} instructions to {filepath}",
            )
        except Exception as e:
            messagebox.showerror("Export Error", f"Could not export file: {e}")

    def run_program(self):
        if self.running:
            return
        self.running = True
        self.run_loop()

    def run_loop(self):
        if not self.running or self.cpu.halted:
            self.running = False
            return
        self.cpu.step()
        self.update_all_displays()
        self.after(self.run_speed, self.run_loop)

    def stop_program(self):
        self.running = False

    def step_program(self):
        if self.running:
            self.stop_program()
        if self.cpu.halted:
            return
        self.cpu.step()
        self.update_all_displays()

    def reset_all(self):
        """Resets the entire simulation, including CPU and GUI."""
        self.stop_program()
        self.cpu.reset()
        for addr in self.screen_pixels.keys():
            self.update_pixel(addr, 0)
        self.update_all_displays()

    def update_all_displays(self):
        self.update_registers_display()
        self.update_memory_display()

    def update_registers_display(self):
        for i, val in enumerate(self.cpu.registers):
            self.reg_labels[i].config(text=f"0x{val:04X} ({val})")
        for flag, val in self.cpu.flags.items():
            self.flag_labels[flag].config(text=str(val))
        pc = self.cpu.pc
        self.pc_label.config(text=f"0x{pc:04X} ({pc})")

    def update_memory_display(self):
        self.memory_view.delete(*self.memory_view.get_children())
        for i in range(256):
            val = self.cpu.memory[i]
            tags = ("current_pc",) if i == self.cpu.pc else ()
            self.memory_view.insert(
                "", "end", values=(f"0x{i:04X}", f"0x{val:04X}", val), tags=tags
            )

        self.memory_view.tag_configure("current_pc", background="#4A6A8A")

        if self.cpu.pc < 256 and self.memory_view.get_children():
            try:
                pc_item = self.memory_view.get_children()[self.cpu.pc]
                if pc_item:
                    self.memory_view.selection_set(pc_item)
                    self.memory_view.see(pc_item)
            except IndexError:
                pass

    def update_pixel(self, address, color_val):
        """Callback to update a single pixel on the canvas."""
        if address in self.screen_pixels:
            gray_val = color_val & 0xFF
            color = f"#{gray_val:02x}{gray_val:02x}{gray_val:02x}"
            self.screen_canvas.itemconfig(self.screen_pixels[address], fill=color)


if __name__ == "__main__":
    app = SimulatorGUI()
    app.mainloop()
