#include <bits/stdc++.h>
using namespace std;
/*
 * author: abdulsmapara
*/

#define TEST_VERSION



int UNIQUE_ID = 01;
int getUniqueId(){
	return (UNIQUE_ID++);
}
int num_nodes_expanded = 0;


typedef pair<int,int> pr;//f-value,ID
typedef priority_queue<pr,vector<pr>,greater<pr> > minHeap;

class Node{
private:
	int cityNum;
	int fvalue;
public:
	//getters and setters
	Node(){
		cityNum = -1;
		fvalue = -1;
	}

	Node(int cityNum,int fvalue){
		this->cityNum = cityNum;
		this->fvalue = fvalue;
	}

	void setCity(int cityNum){
		this->cityNum = cityNum;

	}
	void setFval(int Fval){
		this->fvalue = Fval;
	}
	int getFval(){
		return fvalue;
	}
	int getCity(){
		return cityNum;
	}
};
unordered_map<int,Node> mp;//maps unique id to attributes of a node
class Tree{
public:

	int unique_id;
	vector<Tree*> children;
	Tree* parent;
	set<int> path;
	unordered_map<int,Tree*> tree_cache;

public:
	Tree(int unique_id){
		//create a root
		this->unique_id = unique_id;
		tree_cache.insert(make_pair(unique_id,this));

		this->parent = NULL;
	}
	Tree* search(int id){

		return tree_cache[id];
		// if(this == NULL) return NULL;
		// if(this->unique_id == id){
		// 	return this;
		// }else{
		// 	for(int i=0;i<children.size();i++){
		// 		Tree* tmp = children[i]->search(id);
		// 		if(tmp != NULL){
		// 			return tmp;
		// 		}
		// 	}
		// }
		// return NULL;
		
	}
	void add(int parent_id,int child_id){
		//search parent in tree
		Tree* parent_node = search(parent_id);
		assert(parent_node != NULL);
		Tree* child_node = new Tree(child_id);
		tree_cache[child_id] = child_node;
		child_node->parent = parent_node;
		(parent_node->children).push_back(child_node);

	}
	void print(){
		queue<Tree*> q;
		q.push(this);
		while(!q.empty()){
			
			int x = q.size();
			while(x > 0){
				Tree* t = q.front();
				q.pop();

				cout << mp[t->unique_id].getCity() << " num_child: " << t->children.size() << " , " ;
				for(int i=0;i< t->children.size();i++){
					q.push(t->children[i]);
				}
				x--;
			}
			cout << endl;

		}
	}
	int checkPath(Tree* leaf){
		path.clear();
		int count=0;
		leaf = leaf->parent;
		while(leaf != NULL){
			path.insert(mp[leaf->unique_id].getCity());
			leaf = leaf->parent;
			count++;
		}
		// #ifdef DEBUG
		// 	cout << "SIZE: "<< path.size() << endl;
		// #endif
		if(count == path.size())
			return path.size();
		else
			return -1;
	}
	bool isPossible(Tree* leaf){
		int val = mp[leaf->unique_id].getCity();
		leaf = leaf->parent;
		while(leaf != NULL){
			//cout << mp[leaf->unique_id].getCity() << ' ' << val << endl;
			if(mp[leaf->unique_id].getCity() == val){
				return false;
			}
			leaf = leaf->parent;
		}
		return true;
	}
	void printPath(Tree *leaf){
		stack<int> nodes;
		while(leaf != NULL){
			nodes.push(mp[leaf->unique_id].getCity());
			leaf = leaf->parent;
		}
		cout << "PATH: " << endl;
		while(!nodes.empty()){
			if(nodes.size() > 1)
				cout << nodes.top() << " -> ";
			else
				cout << nodes.top() << endl;
			nodes.pop();
		}
	}
	void citiesInPath(set<int>& cities_in_path,Tree* leaf){
		if(leaf == NULL) return;
		else{

			leaf = leaf -> parent;
			while(leaf != NULL){
				cities_in_path.insert(mp[leaf->unique_id].getCity());
				// #ifdef DEBUG
				// 	cout << "CITIES IN PATH: " << mp[leaf->unique_id].getCity() << endl;
				// #endif
				leaf = leaf->parent;
			}
		}
	}
};

class TSP{
	//definition of TSP problem
private:
	unordered_map<int,int> heuristic_cache;
	minHeap fringeList;
	int numCities;
	vector <vector<int> > distMatrix;
	Tree* tree;
	int startState;
	void setNumCities(int numCities){
		if(numCities < 0) throw "ILLEGAL VALUE OF NUMBER OF CITIES";
		this->numCities = numCities;

	}
	void setDistMatrix(vector<vector<int> > & distanceMatrix){

		distMatrix.clear();
		//cout << distMatrix.size();
		for (int i = 0; i < distanceMatrix.size(); ++i)
		{
			vector<int> temp;
			for(int j = 0;j < distanceMatrix[i].size();j++)
			{
				temp.push_back(distanceMatrix[i][j]);

			}
			distMatrix.push_back(temp);
		}
		// #ifdef DEBUG
		// 	for (int i = 0; i < distMatrix.size(); ++i)
		// 	{
		// 		for(int j=0;j<distMatrix[i].size();j++)
		// 		{
		// 			cout << distMatrix[i][j] << ' ';
		// 		}
		// 		cout << endl;
		// 	}
		// #endif
	}
	void setStartState(int state){
		// #ifdef DEBUG
		// 	cout << "START STATE SET AT " << state << endl;
		// #endif
		this->startState = state;
	}
public:
	TSP():numCities(0){tree = NULL;}
	void setAll(int numCities,vector<vector<int> >& distanceMatrix,int state){
		setNumCities(numCities);
		setDistMatrix(distanceMatrix);
		setStartState(state);
	}
	int minKey(int key[], bool mstSet[],int size)  
	{   
	    int min = INT_MAX, min_index;  
	  
	    for (int v = 0; v < size; v++)  
	        if (mstSet[v] == false && key[v] < min)  
	            min = key[v], min_index = v;  
	  
	    return min_index;  
	}  
	void printMST(int parent[],vector<vector<int> > & graph)  
	{  
	    cout << "Edge \tWeight\n";  
	    for (int i = 1; i < graph.size(); i++)  
	        cout<<parent[i]<<" - "<<i<<" \t"<< graph[i][parent[i]]<<" \n";  
	}  

	int minimumSpanningTree(vector <vector<int> >& graph,int parent[]){
		int key[graph.size()];  
	     
	    bool mstSet[graph.size()];  
	  
	    for (int i = 0; i < graph.size(); i++){ 
	        key[i] = INT_MAX, mstSet[i] = false;
	    }  
	  
	    key[0] = 0;  
	    parent[0] = -1; // First node is always root of MST  
	  	
	    for (int count = 0; count < graph.size() - 1; count++) 
	    {  
	        int u = minKey(key, mstSet,graph.size());  
	  
	        mstSet[u] = true;  
	        for (int v = 0; v < graph.size(); v++)  
	  			if (graph[u][v] && mstSet[v] == false && graph[u][v] < key[v])  
	                parent[v] = u, key[v] = graph[u][v];  
	    }  
	  	int retsum = 0;
	  	for (int i = 1; i < graph.size(); i++)  {
	  		retsum += (graph[i][parent[i]]);
	  	}
	    // print the constructed MST
	    // #ifdef DEBUG  
	    // 	printMST(parent,graph);
	    // 	cout << "retsum " << retsum << endl;
	    // #endif
	    return retsum;
	}
	int heuristic(int state_id){
		if(heuristic_cache[state_id] != 0) return heuristic_cache[state_id];
		set<int> cities_in_path;
		int arr[numCities];
		tree->citiesInPath(cities_in_path,tree->search(state_id));
		vector<vector<int> > graph(numCities - cities_in_path.size(),vector<int>(numCities - cities_in_path.size()));
		unordered_map<int,int> new_to_old;
		int j=0;
		for(int i=0;i < numCities;i++){
			if(cities_in_path.find(i) == cities_in_path.end()){
				new_to_old[j] = i;
				
				j++;
			}
		}
		#ifdef DEBUG
			cout << "j is " << j << endl;	
		#endif
		#ifdef DEBUG
		 	cout << "NODES " << endl;
		#endif
		for(int i=0;i<j;i++){
			graph[i][i] = 0;
			#ifdef DEBUG
				cout <<  new_to_old[i] << ' ';
			#endif
			for(int k=i+1;k<j;k++){
				
				graph[k][i] = distMatrix[new_to_old[i]][new_to_old[k]];
				graph[i][k] = graph[k][i];
			}
		}
		#ifdef DEBUG
			cout << endl;
		#endif	

		//print matrix
		// #ifdef DEBUG
		// 	cout << "MATRIX " << endl;
		// 	for (int i = 0; i < j; ++i)
		// 	{
		// 		for(int k=0;k<j;k++){
		// 			cout << graph[i][k] << ' ';
		// 		}
		// 		cout << endl;
		// 	}
		// #endif


		if(j > 0){
			int parent[graph.size()];
			int sum = minimumSpanningTree(graph,parent);
			int city1 = startState;

			int city2 = 0;
			Tree* end_node = (tree->search(state_id))->parent;
			if(end_node == NULL){
				city2 = city1;
			}else{
				if(end_node->unique_id == startState){
					city2 = city1;
				}else{
					city2 = mp[end_node->unique_id].getCity();
				}
			}
			int mini1 = distMatrix[city1][new_to_old[0]];
			for(int i=1;i<j;i++){
				mini1 = min(distMatrix[city1][new_to_old[i]],mini1);
			}
			int mini2 = distMatrix[city2][new_to_old[0]];
			for(int i=1;i<j;i++){
				mini2 = min(distMatrix[city2][new_to_old[i]],mini2);
			}
			if(city1 != city2) mini1 += mini2;
			// #ifdef TEST_VERSION
			// 	cout << "HEURISTIC VALUE " << (mini1 + sum) << endl;
			// #endif
			return (heuristic_cache[state_id]=(mini1 + sum));
			
		}

		return 0;
	}
	bool isGoalState(int toExpand){
		// if there is a path in a tree that consists of all the vertices return true
		// else return false

		bool ret = (tree->checkPath(tree->search(toExpand)) == numCities and mp[toExpand].getCity() == startState);
		if(ret){
			//print path also
			tree->printPath(tree->search(toExpand));//optimal path

		}
		return ret;
		
	}
	int minCostUtil(){
		bool condition = true;
		while(condition){

			int toExpand = fringeList.top().second;
			Node info = mp[toExpand];

			if(isGoalState(toExpand)){
					condition = false;
			}
			else if(tree->isPossible(tree->search(toExpand))){
				num_nodes_expanded++;
				#ifdef TEST_VERSION
					cout << "EXPANDING " << info.getCity() << " fval: " << info.getFval() << endl;
				#endif
				fringeList.pop();
				for(int i=0;i < numCities;i++){

					if(i != info.getCity()){
						
						//expand
						int id = getUniqueId();
						tree->add(toExpand,id);
						fringeList.push(make_pair(info.getFval() - heuristic(toExpand) + distMatrix[i][info.getCity()] + heuristic(id),id));

						Node temp;
						temp.setCity(i);
						temp.setFval(info.getFval() - heuristic(toExpand) + distMatrix[i][info.getCity()] + heuristic(id));
						mp.insert(make_pair(id,temp));

						//cout << "here " << (tree->search(toExpand) == NULL);	
						
					}
				}
			
				
			}else{
				fringeList.pop();
			}
			
			
		}
		//tree->print();
		return fringeList.top().first;

	}

	/*
	 * The function that solves the TSP using A* algorithm
	 * Input: Adjacency Matrix of the graph
	 * Output: Minimum Cost and optimal path for Travelling Salesman
	*/
	int minCost(){

		int idStartState = getUniqueId();
		tree = new Tree(idStartState);
		Node v;
		v.setCity(startState);
		v.setFval(0+heuristic(idStartState));
		mp.insert(make_pair(idStartState,v));
		fringeList.push(make_pair(heuristic(idStartState),idStartState));
		//  #ifdef DEBUG
		//   	cout << "DEBUG--------------------------------------------------------"<<mp[fringeList.top().second].getFval() <<endl;
		// #endif
		return minCostUtil();

	}

};

signed main(){

	TSP* tsp = new TSP;
	int numCities;
	int startState = 2;	// ASSUMPTION
	cout << "ENTER THE NUMBER OF CITIES/PLACES" << endl;
	
	cin >> numCities;
	if(numCities == 1) {cout << startState << endl;return 0;}
	vector<vector<int> > distanceMatrix(numCities,vector<int>(numCities));
	#ifdef MATRIX_INPUT
		for (int i = 0; i < numCities; ++i)
		{
			for(int j=0;j < numCities;j++){
				//int x,y;cin >> x >> y;
				cin >> distanceMatrix[i][j];
			}
		}
	#else
		for (int i = 0; i < numCities; ++i)
		{
			
			distanceMatrix[i][i]=0;
			for(int j=i+1;j < numCities;j++){
				cout << "ENTER DISTANCE BETWEEN " << (i) << " AND " << (j) << " ";
				cin >> distanceMatrix[i][j];
				distanceMatrix[j][i] = distanceMatrix[i][j];
			}
		}

	#endif
		
	tsp->setAll(numCities,distanceMatrix,startState);
	#ifdef EXTREME_DEBUG
		for (int i = 0; i < numCities; ++i)
		{
			
			distanceMatrix[i][i]=0;
			for(int j=i+1;j < numCities;j++){
				cout << "ENTER DISTANCE BETWEEN " << (i) << " AND " << (j) << " ";
				cin >> distanceMatrix[i][j];
				distanceMatrix[j][i] = distanceMatrix[i][j];
			}
		}
		tsp->setAll(numCities,distanceMatrix,0);
	#endif


	cout << "COST: " << tsp->minCost() << endl;

	cout << "NUMBER OF NODES EXPANDED " << num_nodes_expanded << endl;

	

	delete tsp;

	return 0;
}