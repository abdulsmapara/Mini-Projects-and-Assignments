#include <bits/stdc++.h>
using namespace std;
/*
*   Abdul Sattar Mapara (BT16CSE053)
*   Solution to Travelling Salesman Problem using Genetic Algorithm (AI)
*   C++14
*	Compilation: g++ -std=c++14 TSP.cpp -DINTERACTIVE -o tsp
*	Execution: ./tsp
*   Dt. 25th Sept, 2019
*/
/*Reference : https://towardsdatascience.com/evolution-of-a-salesman-a-complete-genetic-algorithm-tutorial-for-python-6fe5d2b3ca35
*/
#define MUTATION_RATE 41
#define IMPOSSIBLE_CITY INT_MAX
#define MAX_NUMBER_OF_ITERATIONS 10000


int generateRandom(int low=1,int high=100){
	return (rand() % (high - low + 1)) + low;
}
bool cmp(const pair<int,double>& a,const pair<int,double>& b){
	return a.second < b.second;
}
class TSP
{
private:
	int numCities;
	vector <vector<int> > distMatrix;
	vector<vector<int> >  population;
	vector<double> fitness;
	int mutation_rate;
	/*
	 * Sets the matrix for this object to the matrix taken as input
	*/
	void setDistMatrix(vector<vector<int> >& distanceMatrix){

		distMatrix.clear();
		
		for (int i = 0; i < distanceMatrix.size(); ++i)
		{
			vector<int> temp;
			for(int j = 0;j < distanceMatrix[i].size();j++)
			{
				temp.push_back(distanceMatrix[i][j]);

			}
			distMatrix.push_back(temp);
		}
		#ifdef DEBUG
			for (int i = 0; i < distMatrix.size(); ++i)
			{
				for(int j=0;j<distMatrix[i].size();j++)
				{
					cout << distMatrix[i][j] << ' ';
				}
				cout << endl;
			}
		#endif
	}
	/*
	 * Calculates the distance the travelling salesman needs to travel using the route passed
	*/
	int tripDistance(vector<int>& route){
		
		int dist = 0;
		for (int i = 0; i < route.size(); ++i){
			int from = route[i];
			int to = from;
			if((i + 1) < route.size()){
				to = route[i+1];
			}else{
				to = route[0];
			}
			dist += getDistance(from,to);
		}
		return dist;
	}
	/*
	 * Returns the fitness of the route
	 * Fitness = 1.0/tripDistance of the Route
	*/
	double calcFitness(vector<int>& route){

		double fitness=0.0;
		int dist = tripDistance(route);
		if(dist == 0){
			fitness = INFINITY;
		}else{
			fitness = 1.0/((double)dist);
		}
		
		return fitness;
	}
	/*
	 * Creates a random but valid path for Travelling Salesman to take
	*/
	void createRoute(vector<int>& path){
		path.clear();
		for(int i=0; i < numCities; i++)       
		    path.push_back(i);

		unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
		std::shuffle(path.begin(), path.end(), std::default_random_engine(seed));
		#ifdef INTERACTIVE
			cout << "Randomly generated path: ";
			for(int i=0; i < numCities; i++)
				cout << path[i] << ' ';
		#endif
	}
	/*
	 * Creates a bunch of random but valid paths that a Travelling Salesman can take 
	*/
	void createPopulation(vector<vector<int> >& population_arr,int populationSize){
		population_arr.clear();
		vector<int> path;
		for (int i = 0; i < populationSize; ++i){
			createRoute(path);
			population_arr.push_back(path);
			path.clear();
		}
	}
	/*
	 * Ranks the population in increasing order of fitness
	*/
	void rank_population_acc_to_fitness(vector<pair<int,double> >& temp){
		fitness.clear();
		temp.clear();
		#ifdef DEBUG
			cout << "FITNESS VAL:\n";
		#endif
		for(int i=0;i < population.size();i++){
			vector<int> route = population[i];
			double fitness_val = calcFitness(route);
			#ifdef DEBUG
				cout << fitness_val << ' ';
			#endif
			temp.push_back(make_pair(i,fitness_val));

		}
		#ifdef DEBUG
			cout << endl;
		#endif
		sort(temp.begin(),temp.end(),cmp);
		#ifdef DEBUG
			cout << "SORTED POPULATION BASED ON FITNESS:\n";
		#endif
		for (int i = 0; i < temp.size(); ++i)
		{
			#ifdef DEBUG
				cout << temp[i].first << ' ' << temp[i].second << endl;
			#endif
			fitness.push_back(temp[i].second);

		}
		#ifdef DEBUG
			cout << endl;
		#endif
		vector<vector<int> > updatedPopulation;

		for (int i = 0; i < temp.size(); ++i){
			vector<int> pop = population[temp[i].first];
			updatedPopulation.push_back(pop);
		}

		for (int i = 0; i < updatedPopulation.size(); ++i){
			for(int j = 0; j < updatedPopulation[i].size();j++){
				population[i][j] = updatedPopulation[i][j];
				#ifdef DEBUG
					cout << population[i][j] << ' ';
				#endif
			}
			#ifdef DEBUG
				cout << endl;
			#endif
		}


		

	}
	/*
	 * Chooses two indices for crossover opearation
	*/
	pair<int,int> rouletteWheelSelection(const vector<double> & fitness_val){
		
		pair<int,int> ret(make_pair(IMPOSSIBLE_CITY,IMPOSSIBLE_CITY));
		
		vector<double> sum(fitness_val);
		
		double total = 0.0;
		for(int i = 0; i < fitness_val.size();i++){
			total += fitness_val[i];
		}
		assert(total != 0);	//	ASSUMPTION
		for(int i=0; i < sum.size();i++){
			sum[i] /= total;
			if(i != 0){
				sum[i] += sum[i-1];
			}
			#ifdef DEBUG
				cout << sum[i] << ' ';
			#endif
		}
		#ifdef DEBUG
			cout << endl;
		#endif
		int random_num = generateRandom(1,98);
		#ifdef DEBUG
			cout << "RANDOM NUMBER 1 " << random_num << endl;
		#endif
		bool found = false;
		for(int i=0; i < sum.size() and !found;i++){
			if(ceil(sum[i]*100) >= random_num){
				found = true;
				ret.first = i;
			}
		}
		found = false;
		int num_loop = 0;
		do{
			random_num = generateRandom(1,100);
			#ifdef DEBUG
				cout << "RANDOM NUMBER 2 " << random_num << endl;
			#endif
			if(num_loop > 1000){
				random_num = 0;	
			}
			for(int i=0; i < sum.size() and !found;i++){
				if(i != ret.first and ceil(sum[i]*100) >= random_num){
					found = true;
					ret.second = i;
				}
			}
			num_loop++;
		}while(!(ret.first != ret.second and ret.first !=  IMPOSSIBLE_CITY and ret.second != IMPOSSIBLE_CITY));
		assert(ret.first != ret.second);
		assert(ret.first != ret.second and ret.first !=  IMPOSSIBLE_CITY and ret.second != IMPOSSIBLE_CITY and ret.first < population.size() and ret.second < population.size());
		return ret;
	}
	/*
	 * Performs crossover operation between route @ index parent1_id and route @ index parent2_id
	*/
	void crossover(int parent1_id,int parent2_id,vector<int>& child){
		child.clear();
		for(int i=0;i < numCities;i++){
			child.push_back(IMPOSSIBLE_CITY); // some dummy data
		}
		int startPos = generateRandom(0,population[parent1_id].size()-1);
		int endPos = generateRandom(0,population[parent1_id].size()-1);
		int child_start = generateRandom(0,numCities - (abs(endPos - startPos) + 1));
		set<int> stored;
		assert(startPos < numCities);
		assert(endPos < numCities);
		#ifdef DEBUG
			cout << startPos << " is startPos\n";
			cout << endPos << " is endPos\n";
		#endif
		for(int i = min(startPos,endPos); i <= max(startPos,endPos);i++){
			#ifdef DEBUG
				cout << child_start << " is child_start\n";
			#endif
			assert(child_start < numCities);
			child[(child_start++)%numCities] = population[parent1_id][i];
			stored.insert(population[parent1_id][i]);
		}


		for(int i = 0; i < population[parent2_id].size();i++){
			if(stored.find(population[parent2_id][i]) == stored.end()){
				//not found
				bool done = false;
				for(int j = 0; j < numCities and !done; j++)
				{
					if(child[j] == IMPOSSIBLE_CITY)
					{
						child[j] = population[parent2_id][i];
						done = true;
					}
				}
			}
		}
		#ifdef DEBUG
			cout << "AFTER CROSSOVER" << endl;
			for (int i = 0; i < numCities; ++i)
			{
				cout << child[i] << ' ';
			}
			cout << endl;
		#endif

	}
	/*
	 * If mutation rate permits, it swaps two randomly chosen locations in the route
	*/
	void mutate(vector<int>& child){
		int random = generateRandom(1,99);
		if(random <= mutation_rate){
			#ifdef DEBUG
				cout << "MUTATION TAKING PLACE\n";
			#endif
			int pos1 = generateRandom(0,child.size()-1);
			int pos2 = generateRandom(0,child.size()-1);
			#ifdef DEBUG
				cout << "POS: " << pos1 << ' ' << pos2 << endl;
			#endif
			int temp = child[pos1];
			child[pos1] = child[pos2];
			child[pos2] = temp;
			#ifdef DEBUG
				cout << "AFTER MUTATION, CHILD:\n";
				for (int i = 0; i < child.size(); ++i)
				{
					cout << child[i] << ' ';
				}
				cout << endl;
			#endif
		}
	}
	/*
	 * Wrapper function to create new Population-
	 * Choose two candidates for crossover using Roulette Wheel
	 * Perform crossover and mutation
	 * Return new Population
	*/
	void evolvePopulation(vector<vector<int> >& newPopulation){
		newPopulation.clear();
		vector<int> child;
		for(int i = 0; i < population.size();i++){
			pair<int,int> parents = rouletteWheelSelection(fitness);
			assert(parents.first != parents.second);
			#ifdef DEBUG
				cout << "PARENTS:\n";
				for (int j = 0; j < population[parents.first].size(); ++j)
				{
					cout << population[parents.first][j] << ' ';
				}
				cout << endl;
				for (int j = 0; j < population[parents.second].size(); ++j)
				{
					cout << population[parents.second][j] << ' ';
				}
				cout << endl;
			#endif
			child.clear();
			child.resize(numCities);
			crossover(parents.first,parents.second,child);
			mutate(child);
			newPopulation.push_back(child);
		}
	}
	/*
	 * Returns the minimum cost path among all paths present in the population
	*/
	int getMinimumCostPath(vector<int>& min_cost_route){
		min_cost_route.clear();
		// The one with maximum fitness will be at the end

		#ifdef DEBUG
			for (int i = 0; i < population.size(); ++i){
				for(int j = 0; j < population[i].size();j++){
					cout << population[i][j] << ' ';
				}
				cout << "->" << fitness[i] << endl;
			}
		#endif

		for (int i = 0; i < population[population.size()-1].size(); ++i){
			min_cost_route.push_back(population[population.size()-1][i]);
		}
		return tripDistance(min_cost_route);
	}
public:
	TSP(){
		mutation_rate = MUTATION_RATE;
		mutation_rate %= 101;
	}
	/*
	 * Returns the distance between city x and city y
	 * Note that the city number starts from 0
	*/
	int getDistance(int x,int y){

		return distMatrix[x][y];
		//may throw out of bounds error if queried before setAll() is called
	}
	/*
	 * Method to set all entities in this object
	*/
	void setAll(int numCities,vector<vector<int> >& distanceMatrix){
		this->numCities = numCities;
		setDistMatrix(distanceMatrix);
	}

	/*
	 * The function to solve Travelling Salesman Problem(TSP) using Genetic Algorithm
	 * Before calling the function, make sure all attributes of this object are initialized using setAll()		method
	*/	
	void solve(){
		int population_size = generateRandom(4,3200);

		#ifdef DEBUG
			cout << "INITIAL POPULATION SIZE: " << population_size << endl;
		#endif

		createPopulation(population,population_size);
		#ifdef DEBUG
			cout << "POPULATION:\n";
			for (int i = 0; i < population_size; ++i){
				for(int j = 0; j < population[i].size();j++){
					cout << population[i][j] << ' ';
				}
				cout << endl;
			}
		#endif
		int num_iterations = 0;
		vector<vector<int> > newPopulation;
		vector<pair<int,double> > ordered_population;
		int mini = INT_MAX;
		vector<int> tmp;
		vector<int> min_cost_route;

		do{
			rank_population_acc_to_fitness(ordered_population);
			int mini_new = getMinimumCostPath(tmp);
			if(mini_new < mini){
				mini = mini_new;
				min_cost_route.clear();
				for(int x : tmp){
					min_cost_route.push_back(x);
				}
			}
			tmp.clear();
			cout << "---------------MINIMUM COST PATH OBTAINED SO FAR-----------------" << endl;
			cout << "COST: " << mini << endl;
			cout << "PATH: " << endl;
			for (int i = 0; i < min_cost_route.size(); ++i)
			{
				cout << min_cost_route[i] << "->" << ' ';
			}
			cout << min_cost_route[0] << endl;

			evolvePopulation(newPopulation);
			#ifdef DEBUG
				cout << "POPULATION:\n";
				for (int i = 0; i < newPopulation.size(); ++i){
					for(int j = 0; j < newPopulation[i].size();j++){
						cout << newPopulation[i][j] << ' ';

					}
					cout << endl;
				}
			#endif
			for (int i = 0; i < newPopulation.size(); ++i){
				for(int j = 0; j < newPopulation[i].size();j++){
					population[i][j] = newPopulation[i][j];
				}
			}
			newPopulation.clear();

		}while(++num_iterations <= MAX_NUMBER_OF_ITERATIONS);
		cout << "---------------MINIMUM COST PATH OBTAINED AFTER CERTAIN ITERATIONS-----------------" << endl;
		cout << "COST: " << mini << endl;
		cout << "PATH: " << endl;
		for (int i = 0; i < min_cost_route.size(); ++i)
		{
			cout << min_cost_route[i] << " ---> " << ' ';
		}
		cout << min_cost_route[0] << endl;

	}
};
int main()
{
	srand(time(0));

	TSP* tsp = new TSP;

	int numCities;
	#ifdef INTERACTIVE
		cout << "Enter the number of cities ";
	#endif
	cin >> numCities;
	vector<vector<int> > distanceMatrix(numCities,vector<int>(numCities));

	for (int i = 0; i < numCities; ++i)
	{
		distanceMatrix[i][i] = 0;
		#ifdef INTERACTIVE
			for(int j = i+1;j < numCities;++j){
				cout << "Enter distance between " << i << ' ' << j << ' ';
				cin >> distanceMatrix[i][j];
				distanceMatrix[j][i] = distanceMatrix[i][j];
			}
		#else
			//file input
			for(int j=i+1;j < numCities;j++){

				cin >> distanceMatrix[i][j];
				distanceMatrix[j][i] = distanceMatrix[i][j];
			}
		#endif

	}


	tsp->setAll(numCities,distanceMatrix);


	tsp->solve();

	delete tsp;


	return 0;
}