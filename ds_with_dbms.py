import oracledb

DB_USER = "system"
DB_PASSWORD = "YOUR_ORACLE_PASSWORD"  # Replace with your actual system password
DB_DSN = "localhost:1521/XE"

def get_connection():
    try:
        connection = oracledb.connect(
            user=DB_USER,
            password=DB_PASSWORD,
            dsn=DB_DSN
        )
        return connection
    except Exception as e:
        print(f"[!] Database Connection Error: {e}")
        return None

class StudentNode:
    def __init__(self, student_id, name, cgpa):
        self.student_id = int(student_id)
        self.name = name
        self.cgpa = float(cgpa)
        self.next = None

class StudentLinkedList:
    def __init__(self):
        self.head = None

    def insert(self, student_id, name, cgpa):
        new_node = StudentNode(student_id, name, cgpa)
        if not self.head:
            self.head = new_node
            return True
        curr = self.head
        while curr:
            if curr.student_id == student_id:
                return False
            if not curr.next:
                break
            curr = curr.next
        curr.next = new_node
        return True

    def delete(self, student_id):
        curr = self.head
        prev = None
        while curr:
            if curr.student_id == student_id:
                if prev is None:
                    self.head = curr.next
                else:
                    prev.next = curr.next
                return True
            prev = curr
            curr = curr.next
        return False

    def to_list(self):
        records = []
        curr = self.head
        while curr:
            records.append({
                "id": curr.student_id,
                "name": curr.name,
                "cgpa": curr.cgpa
            })
            curr = curr.next
        return records

    def display(self):
        curr = self.head
        if not curr:
            print("\n[!] No records found.")
            return
        print("\n" + "=" * 45)
        print(f"{'ID':<8}{'Name':<25}{'CGPA':<10}")
        print("=" * 45)
        while curr:
            print(f"{curr.student_id:<8}{curr.name:<25}{curr.cgpa:<10.2f}")
            curr = curr.next
        print("=" * 45)

class ActionStack:
    def __init__(self):
        self.stack = []

    def push(self, action_type, student_data):
        self.stack.append((action_type, student_data))

    def pop(self):
        if not self.stack:
            return None
        return self.stack.pop()

class InterviewQueue:
    def __init__(self):
        self.queue = []

    def enqueue(self, student_info):
        self.queue.append(student_info)

    def dequeue(self):
        if not self.queue:
            return None
        return self.queue.pop(0)

    def display(self):
        if not self.queue:
            print("\n[!] The interview queue is currently empty.")
            return
        print("\n" + "-" * 40)
        print(f"Upcoming Interviews ({len(self.queue)} Candidates Waiting):")
        print("-" * 40)
        for idx, student in enumerate(self.queue, start=1):
            print(f"{idx}. ID: {student['id']} | Name: {student['name']} | CGPA: {student['cgpa']}")
        print("-" * 40)

def merge_sort_cgpa(records):
    if len(records) <= 1:
        return records
    mid = len(records) // 2
    left = merge_sort_cgpa(records[:mid])
    right = merge_sort_cgpa(records[mid:])
    sorted_list = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i]["cgpa"] >= right[j]["cgpa"]:
            sorted_list.append(left[i])
            i += 1
        else:
            sorted_list.append(right[j])
            j += 1
    sorted_list.extend(left[i:])
    sorted_list.extend(right[j:])
    return sorted_list

def binary_search_id(records, target_id):
    low = 0
    high = len(records) - 1
    while low <= high:
        mid = (low + high) // 2
        if records[mid]["id"] == target_id:
            return records[mid]
        elif records[mid]["id"] < target_id:
            low = mid + 1
        else:
            high = mid - 1
    return None

def load_data_from_oracle(student_list):
    conn = get_connection()
    if not conn:
        print("[!] Database offline. Operating with local memory.")
        return
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT student_id, full_name, cgpa FROM Students")
        rows = cursor.fetchall()
        for row in rows:
            student_list.insert(row[0], row[1], row[2])
        print(f"[OK] Successfully loaded {len(rows)} records from Oracle DB into Linked List.")
    except Exception as e:
        print(f"[!] Query Error: {e}")
    finally:
        cursor.close()
        conn.close()

def insert_student_to_db(sid, name, cgpa, dept_id=101, grad_year=2026):
    conn = get_connection()
    if not conn:
        return False
    cursor = conn.cursor()
    try:
        sql = """INSERT INTO Students (student_id, full_name, email, phone, cgpa, dept_id, grad_year) 
                 VALUES (:1, :2, :3, :4, :5, :6, :7)"""
        email = f"{name.lower().replace(' ', '')}{sid}@college.edu"
        phone = "9800000000"
        cursor.execute(sql, (sid, name, email, phone, cgpa, dept_id, grad_year))
        conn.commit()
        return True
    except Exception as e:
        print(f"[!] Oracle DB Insert Error: {e}")
        return False
    finally:
        cursor.close()
        conn.close()

def delete_student_from_db(sid):
    conn = get_connection()
    if not conn:
        return False
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM Students WHERE student_id = :1", (sid,))
        conn.commit()
        return True
    except Exception as e:
        print(f"[!] Oracle DB Delete Error: {e}")
        return False
    finally:
        cursor.close()
        conn.close()

def main():
    s_list = StudentLinkedList()
    undo_stack = ActionStack()
    i_queue = InterviewQueue()

    load_data_from_oracle(s_list)

    while True:
        print("\n==========================================")
        print("  CAMPUS PLACEMENT MANAGEMENT SYSTEM")
        print("==========================================")
        print("1. Add New Student")
        print("2. Display All Students (Linked List)")
        print("3. Generate Merit List (Merge Sort)")
        print("4. Search Student by ID (Binary Search)")
        print("5. Add Candidate to Interview Queue")
        print("6. Conduct Next Interview (Dequeue)")
        print("7. View Interview Queue")
        print("8. Undo Last Added Student")
        print("9. Exit")
        print("==========================================")

        choice = input("Enter choice (1-9): ").strip()

        if choice == "1":
            try:
                sid = int(input("Enter Student ID: "))
                name = input("Enter Full Name: ").strip()
                cgpa = float(input("Enter CGPA (0.0 - 10.0): "))
                if not (0.0 <= cgpa <= 10.0):
                    print("[!] Invalid CGPA range.")
                    continue
                if insert_student_to_db(sid, name, cgpa):
                    s_list.insert(sid, name, cgpa)
                    undo_stack.push("INSERT", {"id": sid, "name": name, "cgpa": cgpa})
                    print(f"[OK] Student '{name}' successfully inserted into DB and Linked List.")
                else:
                    print(f"[!] Failed to insert student record.")
            except ValueError:
                print("[!] Invalid input format.")

        elif choice == "2":
            s_list.display()

        elif choice == "3":
            records = s_list.to_list()
            if not records:
                print("\n[!] No records available to sort.")
                continue
            sorted_records = merge_sort_cgpa(records)
            print("\n" + "=" * 48)
            print("         MERIT LIST (SORTED BY CGPA)       ")
            print("=" * 48)
            print(f"{'Rank':<6}{'ID':<8}{'Name':<24}{'CGPA':<10}")
            print("-" * 48)
            for rank, item in enumerate(sorted_records, start=1):
                print(f"{rank:<6}{item['id']:<8}{item['name']:<24}{item['cgpa']:<10.2f}")
            print("=" * 48)

        elif choice == "4":
            try:
                target = int(input("Enter Student ID to Search: "))
                records = sorted(s_list.to_list(), key=lambda x: x["id"])
                result = binary_search_id(records, target)
                if result:
                    print("\n[Record Found]:")
                    print(f"ID   : {result['id']}")
                    print(f"Name : {result['name']}")
                    print(f"CGPA : {result['cgpa']:.2f}")
                else:
                    print(f"\n[!] Student record with ID {target} was not found.")
            except ValueError:
                print("[!] Please enter a valid numeric ID.")

        elif choice == "5":
            try:
                target = int(input("Enter Student ID to Schedule: "))
                records = sorted(s_list.to_list(), key=lambda x: x["id"])
                candidate = binary_search_id(records, target)
                if candidate:
                    i_queue.enqueue(candidate)
                    print(f"[OK] Candidate '{candidate['name']}' scheduled in interview queue.")
                else:
                    print("[!] Student ID not found.")
            except ValueError:
                print("[!] Please enter a valid numeric ID.")

        elif choice == "6":
            candidate = i_queue.dequeue()
            if candidate:
                print("\n" + "*" * 40)
                print("CALLING CANDIDATE FOR INTERVIEW:")
                print(f"ID   : {candidate['id']}")
                print(f"Name : {candidate['name']}")
                print(f"CGPA : {candidate['cgpa']}")
                print("*" * 40)
            else:
                print("\n[!] No candidates in queue.")

        elif choice == "7":
            i_queue.display()

        elif choice == "8":
            last_action = undo_stack.pop()
            if not last_action:
                print("\n[!] No actions to undo.")
                continue
            act_type, data = last_action
            if act_type == "INSERT":
                delete_student_from_db(data["id"])
                s_list.delete(data["id"])
                print(f"[Undo Successful] Removed student '{data['name']}' (ID: {data['id']}) from DB and List.")

        elif choice == "9":
            print("\nExiting application.")
            break

        else:
            print("[!] Invalid option. Select between 1 and 9.")

if __name__ == "__main__":
    main()
