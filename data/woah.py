#Minor thing I've noticed, Gavin. If no questions.json folder exists, it will make a new one and func correctly. If Questions.json is EMPTY, the program won't run.
#You might know the fix, my brain too small

import json
import tkinter as tk
from tkinter import ttk, messagebox

class CreateToolTip:
    #I'm making this to make tool tips when you hover your mouse. I hear that helps a lot with guiding people! 
    def __init__(self, widget, text='widget info'):
        self.waittime = 500 #Make sure you have some value here! Otherwise, it'll show up all the time :v!
        self.wraplength = 200 #Don't shorten imo but you can
        self.widget = widget
        self.text = text
        self.widget.bind("<Enter>", self.enter) #when mouse enters widget
        self.widget.bind("<Leave>", self.leave) #when mouse leaves widget
        self.widget.bind("<Motion>", self.motion) #when mouse moves inside widget
        self.id = None
        self.tw = None #tooltip window reference
        self.x = 0 #x and y are for mouse, don't touch
        self.y = 0

    def enter(self, event=None): #When mouse enters, call. Get mouse pos and schedule
        self.x = event.x_root
        self.y = event.y_root
        self.schedule()

    def leave(self, event=None): #When mouse leaves, call removals and hide. 
        self.unschedule()
        self.hidetip()

    def schedule(self): #Remove any other widget schedules, then get widget hover and use tip
        self.unschedule()
        self.id = self.widget.after(self.waittime, self.showtip)

    def unschedule(self): #Cancel any scheduled tips. 
        id_ = self.id
        self.id = None
        if id_:
            self.widget.after_cancel(id_)

    def motion(self, event): #update mouse position inside widget (do I need this? Dont feel like removing)
        self.x = event.x_root
        self.y = event.y_root

    def showtip(self):
        x = self.x + 10 #change these to influence where the tip appears by mouse
        y = self.y + 5
        self.tw = tk.Toplevel(self.widget) #places it above at top level
        self.tw.wm_overrideredirect(True) #this removes borders/titles. We don't want any
        self.tw.wm_geometry(f"+{x}+{y}") #this is for positioning the widget
        label = tk.Label(self.tw, text=self.text, justify='left', background="#ffffe0", relief='solid', borderwidth=1, wraplength=self.wraplength)
        label.pack(ipadx=1) #label put inside tooltip window here, internal pad. 

    def hidetip(self): #if tolltip exists, explode it. 
        if self.tw:
            self.tw.destroy() #impossible. Die.
        self.tw = None
        self.unschedule()  #pending tooltips get removed here. 

class JsonParse(tk.Tk):
    def __init__(self, json_file):
        super().__init__()
        self.title("Quiz Question Manager")
        self.geometry("1100x650") #This thing really doesn't wanna be much smaller width-wise
        self.configure(bg="#d0f0c0")  #This configure changes the color of parser.
        self.json_file = json_file
        self.data = self.load_data()
        self.current_index = 0
        self.set_style() #call the style function when using. 
        self.create_widgets()
        self.update_display()

    #This is, uh, basically just what you think. Everything here is for style changes.
    def set_style(self):
        self.style = ttk.Style(self) #makes and puts theme
        self.style.theme_use("clam") 
        
        #Nobody can stop me from using comic sans right now. 2 fonts mean bold or not bold. You can play around with changing the 2 font styles. 
        fontbold = ("Comic Sans MS", 11, "bold")
        fontreg = ("Comic Sans MS", 10)
        
        #I'll explain each style thing below for testing/changing.

        #TLabelFrame is all of the frames surrounding the words like ID, Questions, and Help/Instructions. They're big parts of the widget. The outer box, basically
        self.style.configure("TLabelframe", background="#ffe4b5", foreground="#444444", font=fontbold, borderwidth=2)

        #Question Details and Help/Instructions, the actual words/frame this is those. 
        self.style.configure("TLabelframe.Label", background="#ffe4b5", foreground="#444444", font=fontbold)
        
        #ID, Questions, Choices, Answers words. 
        self.style.configure("TLabel", background="#ffe4b5", foreground="#333333", font=fontreg)
        
        #Buttons. 
        self.style.configure("TButton", background="#ff69b4", foreground="white", font=fontbold, padding=6)

        #When you hover a button, color. Changing this might make them UNREADABLE when hovering, be careful. 
        self.style.map("TButton", background=[("active", "#ff85c0")])
        
        #Entry fields. As in, the actual font of the things professors will type
        self.style.configure("TEntry", font=fontreg)
        
        #Font and colors for Text widget. This is that Question Field for instance. 
        self.text_font = fontreg
        self.text_bg = "#fffacd"
        self.text_fg = "#000000"

    def load_data(self):
        try:
            with open(self.json_file, 'r') as f:
                return json.load(f)
        except FileNotFoundError:
            return []

    def save_data(self):
        with open(self.json_file, 'w') as f:
            json.dump(self.data, f, indent=2)

    def create_widgets(self):
        #Changes the frame and details with different colors, padding, relief, and using packs. 
        self.header_frame = tk.Frame(self, bg="#ffdead", bd=5, relief="raised")
        self.header_frame.pack(fill="x", padx=10, pady=10)
        header_label = tk.Label(self.header_frame, text="Welcome to the Biology Quiz Question Maker/Editor!", font=("Comic Sans MS", 20, "bold"), bg="#ffdead", fg="#333333")
        header_label.pack(pady=5)
        
        #Main container holds the quiz area (left) and help panel (right)
        container = tk.Frame(self, bg="#d0f0c0")
        container.pack(fill="both", expand=True, padx=10, pady=5)
        
        #Left Side Of Window
        self.main_frame = tk.Frame(container, bg="#d0f0c0")
        self.main_frame.grid(row=0, column=0, sticky="nsew", padx=(0,10))
        
        # --- Frame for displaying question details ---
        self.details_frame = ttk.LabelFrame(self.main_frame, text="Question Details", padding=(10, 10))
        self.details_frame.grid(row=0, column=0, padx=10, pady=10, sticky="nsew")
        self.details_frame.config(relief="groove") #small change
        
        # Question ID
        ttk.Label(self.details_frame, text="ID:").grid(row=0, column=0, sticky="w", pady=4) #add pad
        self.id_var = tk.StringVar()
        self.id_entry = ttk.Entry(self.details_frame, textvariable=self.id_var, state="disabled", width=5)
        self.id_entry.grid(row=0, column=1, sticky="ew", pady=4)
        CreateToolTip(self.id_entry, "Unique question identifier (not editable).") #using tooltip here
        
        # Question
        ttk.Label(self.details_frame, text="Question:").grid(row=1, column=0, sticky="nw", pady=4)
        self.question_text = tk.Text(self.details_frame, height=3, width=50, wrap="word", bg=self.text_bg, fg=self.text_fg, font=self.text_font)
        self.question_text.grid(row=1, column=1, sticky="ew", pady=4)
        CreateToolTip(self.question_text, "Enter the quiz question here.")
        
        # Choices
        ttk.Label(self.details_frame, text="Choices:").grid(row=2, column=0, sticky="nw", pady=4)
        self.choices_frame = ttk.Frame(self.details_frame)
        self.choices_frame.grid(row=2, column=1, sticky="ew", pady=4)
        self.choice_vars = [tk.StringVar() for _ in range(4)]
        self.choice_entries = []
        for i in range(4):
            ttk.Label(self.choices_frame, text=f"Choice {i+1}:").grid(row=i, column=0, sticky="w", padx=(0, 5))
            entry = ttk.Entry(self.choices_frame, textvariable=self.choice_vars[i], width=30)
            entry.grid(row=i, column=1, sticky="ew", pady=2)
            self.choice_entries.append(entry)
            CreateToolTip(entry, f"Enter choice {i+1} for the answer.")
        
        # Answer
        ttk.Label(self.details_frame, text="Answer:").grid(row=3, column=0, sticky="w", pady=4)
        self.answer_var = tk.StringVar()
        self.answer_entry = ttk.Entry(self.details_frame, textvariable=self.answer_var, width=30)
        self.answer_entry.grid(row=3, column=1, sticky="ew", pady=4)
        CreateToolTip(self.answer_entry, "Enter the correct answer here.")
        
        # --- Frame for navigation and actions ---
        self.nav_frame = ttk.Frame(self.main_frame, padding=(10, 5))
        self.nav_frame.grid(row=1, column=0, pady=10)
        
        self.prev_button = ttk.Button(self.nav_frame, text="Previous", command=self.show_previous)
        self.prev_button.grid(row=0, column=0, padx=6)
        CreateToolTip(self.prev_button, "Show the previous question.")
        
        self.next_button = ttk.Button(self.nav_frame, text="Next", command=self.show_next)
        self.next_button.grid(row=0, column=1, padx=6)
        CreateToolTip(self.next_button, "Show the next question.")
        
        self.add_button = ttk.Button(self.nav_frame, text="Add New", command=self.add_question)
        self.add_button.grid(row=0, column=2, padx=6)
        CreateToolTip(self.add_button, "Add a new question to the quiz.")
        
        self.remove_button = ttk.Button(self.nav_frame, text="Remove", command=self.remove_question)
        self.remove_button.grid(row=0, column=3, padx=6)
        CreateToolTip(self.remove_button, "Remove the current question.")
        
        self.save_button = ttk.Button(self.nav_frame, text="Save", command=self.save_current_data)
        self.save_button.grid(row=0, column=4, padx=6)
        CreateToolTip(self.save_button, "Save changes to the questions file.")
        
        # Status Label
        self.status_label = ttk.Label(self, text="", anchor=tk.W, background="#d0f0c0", font=("Comic Sans MS", 10, "italic"), foreground="#333333")
        self.status_label.pack(fill="x", padx=10, pady=5)
        
        #Right Side Of Window
        self.help_frame = ttk.LabelFrame(container, text="Help & Instructions", padding=(10, 10))
        self.help_frame.grid(row=0, column=1, sticky="nsew", padx=(10,0), pady=10)
        help_text = (
            "• ID: This shows what question number you're on (this isn't editable).\n\n"
            "• Question: Click within the text box and enter the text of the quiz question.\n\n"
            "• Choices: Fill each in with the possible answer options.\n\n"
            "• Answer: Specify the correct answer from the choices.\n\n"
            "• Below Are The Navigation Buttons:\n"
            "    - Previous/Next: Browse through existing questions.\n\n"
            "    - Add New: Create a new question entry to fill out.\n\n"
            "    - Remove: Delete the current question you are on.\n\n"
            "    - Save: Save all changes and updated questions.\n\n"
            "Feel Free to hover over the controls for tips!"
        )
        help_label = tk.Label(self.help_frame, text=help_text, justify="left", background="#ffe4b5", font=("Comic Sans MS", 10), wraplength=250)
        help_label.pack(fill="both", expand=True)
        
        # --- Configure grid weights to make the UI resizable ---
        container.columnconfigure(0, weight=3)
        container.columnconfigure(1, weight=1)
        container.rowconfigure(0, weight=1)
        self.main_frame.columnconfigure(0, weight=1)
        self.details_frame.columnconfigure(1, weight=1)

    def update_display(self):
        if self.data:
            current_question = self.data[self.current_index]
            self.id_var.set(str(current_question['id']))
            self.question_text.delete("1.0", tk.END)
            self.question_text.insert(tk.END, current_question['question'])
            for i, choice in enumerate(current_question['choices']):
                self.choice_vars[i].set(choice)
            self.answer_var.set(current_question['answer'])

            self.status_label.config(text=f"Question {self.current_index + 1} of {len(self.data)}")
        else:
            self.clear_fields()
            self.status_label.config(text="No questions loaded.")

    def clear_fields(self):
        self.id_var.set("")
        self.question_text.delete("1.0", tk.END)
        for var in self.choice_vars:
            var.set("")
        self.answer_var.set("")

    def show_next(self):
        if self.data:
            self.save_current_data() # Save changes before moving
            if self.current_index < len(self.data) - 1:
                self.current_index += 1
                self.update_display()
            else:
                messagebox.showinfo("End of Questions", "You've reached the last question.")
        else:
            messagebox.showinfo("No Questions", "No questions to show.")

    def show_previous(self):
        if self.data:
            self.save_current_data() # Save changes before moving
            if self.current_index > 0:
                self.current_index -= 1
                self.update_display()
            else:
                messagebox.showinfo("Start of Questions", "You're at the first question.")
        else:
            messagebox.showinfo("No Questions", "No questions to show.")

    def add_question(self):
        self.save_current_data() # Save current changes
        self.clear_fields()
        new_id = max([q['id'] for q in self.data], default=0) + 1
        self.id_var.set(str(new_id))
        self.data.append({'id': new_id, 'question': '', 'choices': ['', '', '', ''], 'answer': ''})
        self.current_index = len(self.data) - 1
        self.update_display()
        self.status_label.config(text="New question added. Please fill in the details and save.")

    def remove_question(self):
        if self.data:
            if messagebox.askyesno("Confirm", "Are you sure you want to remove this question?"):
                removed_id = self.data[self.current_index]['id']
                del self.data[self.current_index]
                self.current_index = min(self.current_index, len(self.data) - 1)
                self.update_display()
                self.status_label.config(text=f"Question with ID {removed_id} removed.")
                if not self.data:
                    self.clear_fields()
                    self.status_label.config(text="No questions available.")
        else:
            messagebox.showinfo("No Questions", "No questions to remove.")

    def save_current_data(self):
        if self.data:
            try:
                self.data[self.current_index]['question'] = self.question_text.get("1.0", tk.END).strip()
                self.data[self.current_index]['choices'] = [var.get() for var in self.choice_vars]
                self.data[self.current_index]['answer'] = self.answer_var.get()
                self.save_data()
                self.status_label.config(text="Changes saved.")
            except Exception as e:
                messagebox.showerror("Error Saving", f"An error occurred while saving: {e}")

if __name__ == "__main__":
    app = JsonParse("questions.json")
    app.mainloop()
