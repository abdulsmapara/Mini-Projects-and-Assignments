#include <bits/stdc++.h>
using namespace std;


typedef enum {NIL=0,NEGATIVE=-1,POSITIVE=1} assignments;

class Representations{

private:
	vector<assignments> clause;		// a clause with 5 variables (c1  or c2 or ~c5) -> POSITIVE POSITIVE NIL NIL NEGATIVE
public:

	Representations(int num_of_variables){
		clause.resize(num_of_variables,NIL);
	}
	void add(int index , assignments assgn){
		if(index < 0 or index >= clause.size()){
			throw "OUT OF BOUNDS EXCEPTION";
		}else{
			clause[index] = assgn;
		}
	}
	void print() const{
		int i = 1;
		for(assignments assgn : clause){
			cout << i << ":" << assgn << ' ';
			i++;
		}
		cout << endl;
	}
	assignments get_assignment(int index){
		if(index < 0 or index >= clause.size()){
			throw "OUT OF BOUNDS EXCEPTION";
		}
		return clause[index];
	}
};
class SAT{
private:
	int num_of_variables;
	int num_of_clauses;
	vector<Representations> set_of_clauses;
	vector<assignments> assignment_to_variables;
public:
	SAT(int num_of_variables , int num_clauses){
		this->num_of_variables = num_of_variables;
		this->num_of_clauses = num_clauses;
		assignment_to_variables.resize(num_of_variables,NIL);
	}
	void add_representation(Representations representation){
		set_of_clauses.push_back(representation);
	}
	void print() const{
		for(int i = 0; i < set_of_clauses.size();i++){
			set_of_clauses[i].print();
		}
	}

	bool check_consistency(){
		bool is_consistent = true;
		for(int i = 0; i < num_of_clauses and is_consistent; i++){
			Representations r = set_of_clauses[i];
			for(int j = 0; j < num_of_variables; j++){
				if(r.get_assignment(i) == NEGATIVE){
					is_consistent = false;
				}
			}
		}
		return is_consistent;
	}
	void print_assignments(){
		for (int i = 0; i < assignment_to_variables.size(); ++i){
			cout << (i+1) << " : " << assignment_to_variables[i] << ", ";
		}
		cout << endl;
	}


	void assign_variable(int index, assignments assgn){
		assignment_to_variables[index] = assgn;
	}
	friend bool DPLL(SAT&);
	friend void simplify(SAT&,int,assignments);
	friend bool is_it_empty(const SAT&);
	friend pair<int,assignments> choose_literal(SAT);
};

void simplify(SAT& sat, int index, assignments assgn){
	sat.assign_variable(index, assgn);

	for(int i = 0; i < sat.set_of_clauses.size(); i++){
		if(sat.set_of_clauses[i].get_assignment(index) == assgn){
			for(int j = 0; j < sat.num_of_variables;j++){
				sat.set_of_clauses[i].add(j, NIL);
			}
		}
		
	}
	
	assignments negative_of_assgn = POSITIVE;
	if(assgn == POSITIVE){
		negative_of_assgn = NEGATIVE;
	}
	for(int i = 0; i < sat.set_of_clauses.size(); i++){
		
		if(sat.set_of_clauses[i].get_assignment(index) == negative_of_assgn){
			sat.set_of_clauses[i].add(index, NIL);
		}
		
	}	
}

bool is_it_empty(const SAT& sat){
	bool empty = true;
	for (int i = 0; i < sat.set_of_clauses.size() and empty; ++i){
		Representations r = sat.set_of_clauses[i];
		for(int j = 0; j < sat.num_of_variables and empty; j++){
			if(r.get_assignment(j) != NIL){
				empty = false;
			}
		}
	}

	return empty;
}

pair<int,assignments> choose_literal(SAT sat){
	//	BASED ON FREQUENCY
	map<pair<int,assignments>, int> mp;
	for (int i = 0; i < sat.set_of_clauses.size(); ++i)
	{
		for(int j = 0; j < sat.num_of_variables; j++)
		{
			if(sat.set_of_clauses[i].get_assignment(j) != NIL){
				mp[make_pair(j,sat.set_of_clauses[i].get_assignment(j))]++;	
			}
			
		}
	}
	assert(mp.size() > 0);
	int maxi = -1;
	pair<int, assignments> selected;
	for(auto it = mp.begin(); it != mp.end(); it++){
		if(maxi < it->second){
			maxi = it->second;
			selected = it->first;
		}
	}
	return selected;

}
// pair<int,assignments> choose_literal(SAT sat){
// 	//	BASED ON MINIMUM SIZE
// 	map<int, int> mp;
// 	for (int i = 0; i < sat.set_of_clauses.size(); ++i)
// 	{
// 		int count = 0;
// 		for(int j = 0; j < sat.num_of_variables; j++)
// 		{
// 			if(sat.set_of_clauses[i].get_assignment(j) != NIL){
// 				count++;	
// 			}
			
// 		}
// 		if(count != 0){
// 			mp[i] = count;
// 		}
// 	}
// 	assert(mp.size() > 0);
// 	int mini = sat.num_of_variables;
// 	pair<int,assignments> selected;
// 	int selected_clause;
// 	for(auto it = mp.begin(); it != mp.end(); it++){
// 		if(mini > it->second){
// 			mini = it->second;
// 			selected_clause = it->first;
// 		}
// 	}
// 	for (int i = 0; i < sat.num_of_variables; ++i){
// 		if(sat.set_of_clauses[selected_clause].get_assignment(i) != NIL){
// 			selected = make_pair(i,sat.set_of_clauses[selected_clause].get_assignment(i));
// 			break;
// 		}
// 	}
// 	return selected;
// }
bool DPLL(SAT& sat){

	//reference: http://www.cs.miami.edu/home/geoff/Courses/CSC648-12S/Content/DPLL.shtml

	// if sat is empty return TRUE

	if(is_it_empty(sat)){
		return true;
	}else{
		// SAT sat is not empty
		//identify unit clauses 
		int unit_clause = -1;
		map<int,assignments> mp;
		set<int> not_pure_literals;
		int pure_literal = -1;
		
		do{
			unit_clause = -1;
			int var = -1;
			sat.print();
			cout << endl;
			for(int i = 0; i < sat.set_of_clauses.size() and unit_clause == -1;i++){
				int count = 0;
				Representations r = sat.set_of_clauses[i];
				for(int j = 0; j < sat.num_of_variables and count <= 1;j++){
					if(r.get_assignment(j) != NIL){
						count++;
					}
				}
				if(count == 1){
					unit_clause = (i+1);
					r = sat.set_of_clauses[i];
					for(int j = 0; j < sat.num_of_variables;j++){
						if(r.get_assignment(j) != NIL){
							var = j;
						}
					}	
				}
			}
			if(unit_clause != -1){
				cout << "UNIT CLAUSE: " << unit_clause << endl;
				for (int i = 0; i < sat.set_of_clauses.size(); ++i){
					int count = 0;
					int num_var = -1;
					Representations r = sat.set_of_clauses[i];
					for(int j = 0; j < sat.num_of_variables and count <= 1;j++){
						if(r.get_assignment(j) != NIL){
							count++;
						}
					}
					if(count == 1 and unit_clause != (i+1)){
						assignments a1 = sat.set_of_clauses[unit_clause-1].get_assignment(var);
						assignments a2 = sat.set_of_clauses[i].get_assignment(var);
						if(a1 != NIL and a2 != NIL and a1 != a2){
							return false;
						}
					}
				}
				cout << endl;
				sat.print();

				cout << endl;
				simplify(sat, var , sat.set_of_clauses[unit_clause-1].get_assignment(var));
				
			}
			

		}while(unit_clause != -1);
		
		do{
			pure_literal = -1;
			not_pure_literals.clear();
			mp.clear();
			for(int i = 0; i < sat.set_of_clauses.size();i++){
				Representations r = sat.set_of_clauses[i];
				for(int j = 0; j < sat.num_of_variables;j++){
					if(mp.count(j+1) == 0){
						assignments assgn = r.get_assignment(j);
						if(assgn != NIL){
							mp[j+1] = assgn;
						}
					}else{
						if(r.get_assignment(j) != NIL and mp[j+1] != r.get_assignment(j)){
							not_pure_literals.insert(j+1);
						}
					}
				}
			}

			for(int i = 0; i < sat.num_of_variables and pure_literal == -1;i++){
				
				if(not_pure_literals.find(i+1) == not_pure_literals.end()){
					bool is_pos_or_neg = false;
					for(int j = 0; j < sat.set_of_clauses.size() and !is_pos_or_neg; j++){
						if(sat.set_of_clauses[j].get_assignment(i) != NIL){
							is_pos_or_neg = true;
						}
					}
					if(is_pos_or_neg){
						pure_literal = (i+1);
					}
				}
			}

			if(pure_literal != -1){
				cout << "PURE LITERAL: " << pure_literal << endl;
				assignments assgn = NIL;
				for(int i = 0; i < sat.set_of_clauses.size();i++){
					if(sat.set_of_clauses[i].get_assignment(pure_literal-1) != NIL){
						assgn = sat.set_of_clauses[i].get_assignment(pure_literal-1);
						break;
					}
				}
				assert(assgn != NIL);
				simplify(sat,pure_literal-1,assgn);

			}
		}while(pure_literal != -1);
		
		if(is_it_empty(sat)){
			return true;
		}
		pair<int,assignments> l = choose_literal(sat);	// first indicates variable number, second indicates sign
		cout << "CHOSEN LITERAL: " << l.first << ' ' << l.second << endl;

		vector<Representations> save(sat.set_of_clauses);
		simplify(sat,l.first,l.second);
		sat.print();
		cout << endl;
		bool ret1 = DPLL(sat);
		if(ret1){

			return ret1;
		}else{
			assignments assgn_val = POSITIVE;
			if(l.second == POSITIVE){
				assgn_val = NEGATIVE;
			}
			l.second = assgn_val;
			sat.set_of_clauses.clear();
			for(int i=0;i < save.size();i++){
				sat.set_of_clauses.push_back(save[i]);
			}
			simplify(sat, l.first, l.second);
			sat.print();
			cout << endl;
			bool ret2 = DPLL(sat);
			return ret2;
		}

	}

}
int main(){

	//freopen("input.cnf","r",stdin);	//	ASSUMING INPUT TO BE IN DIMACS FORMAT

	string str;
	do{
		char ch;
		cin >> ch;
		if(ch == 'c'){
			getline(cin,str);
			str = "";	// to prevent being interpreted as "cnf"
			//ignore
		}else{
			assert(ch == 'p');
			cin >> str;	// this would be cnf
		}
	}while(str != "cnf");

	int num_vars;
	cin >> num_vars;

	int num_clauses;
	cin >> num_clauses;

	SAT sat = SAT(num_vars,num_clauses);
	for (int i = 0; i < num_clauses; ++i)
	{
		int n;
		Representations representation = Representations(num_vars);
		do{
			cin >> n;
			if(n > 0){
				representation.add(n-1,POSITIVE);
			}else if(n < 0){
				representation.add(abs(n)-1,NEGATIVE);
			}
		}while(n != 0);
		sat.add_representation(representation);
	}
	sat.print();


	cout << endl;
	bool solvable = DPLL(sat);
	cout << "SAT satisfiability: " << solvable  << endl;
	if(solvable){
		sat.print_assignments();
	}
	return 0;
}