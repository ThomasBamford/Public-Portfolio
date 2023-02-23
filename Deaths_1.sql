SELECT * FROM Covid_Data..Covid_Deaths$
WHERE continent IS NOT NULL
ORDER BY 3,4

-- Select data to use:
SELECT 
	location, date, total_cases, new_cases, total_deaths, population
FROM 
	Covid_Data..Covid_Deaths$
WHERE continent IS NOT NULL
ORDER BY   
	1,2

-- Total Cases vs Total Deaths
SELECT 
	location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM 
	Covid_Data..Covid_Deaths$
WHERE continent IS NOT NULL
AND
	location LIKE '%United States%'
ORDER BY   
	1,2

-- Total Cases vs Population
SELECT 
	location, date, total_cases, population, (total_cases/population)*100 AS percent_population_infected
FROM 
	Covid_Data..Covid_Deaths$
WHERE
	location = 'United States'
AND continent IS NOT NULL
ORDER BY   
	1,2
	
-- Highest Infection Rates
SELECT
	location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 AS percent_population_infected
FROM
	Covid_Data..Covid_Deaths$
WHERE continent IS NOT NULL
GROUP BY
	location, population
ORDER BY
	percent_population_infected DESC

-- Countries by death count
SELECT
	location, MAX(CAST(total_deaths AS BIGINT)) as highest_death_count
FROM
	Covid_Data..Covid_Deaths$
WHERE continent IS NOT NULL
GROUP BY
	location
ORDER BY
	highest_death_count DESC

-- BREAK THINGS DOWN BY CONTINENT

-- Continents with highest population death count

SELECT location, MAX(cast(total_deaths AS int)) as total_death_count
FROM
	Covid_Data..Covid_Deaths$
WHERE continent IS null
GROUP BY 
	location
ORDER BY
	total_death_count DESC

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as death_percentage
From Covid_Data..Covid_Deaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as rolling_people_vaccinated
--, (rolling_people_vaccinated/population)*100
From Covid_Data..Covid_Deaths$ dea
Join Covid_Data..Covid_Vaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, rolling_people_vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as rolling_people_vaccinated
--, (rolling_people_vaccinated/population)*100
From Covid_Data..Covid_Deaths$ dea
Join Covid_Data..Covid_Vaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (rolling_people_vaccinated/Population)*100
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP table if exists #percent_population_vaccinated
Create Table #percent_population_vaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
rolling_people_vaccinated numeric
)

Insert into #percent_population_vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as rolling_people_vaccinated
--, (rolling_people_vaccinated/population)*100
From Covid_Data..Covid_Deaths$ dea
Join Covid_Data..Covid_Vaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (rolling_people_vaccinated/Population)*100
From #percent_population_vaccinated

-- Creating View to store data for later visualizations


Create View percent_population_vaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as rolling_people_vaccinated
--, (rolling_people_vaccinated/population)*100
From Covid_Data..Covid_Deaths$ dea
Join Covid_Data..Covid_Vaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
