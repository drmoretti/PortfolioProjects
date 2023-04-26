SELECT * 
FROM Portfolio..covid_deaths
ORDER BY  3,4;

--SELECT * 
--FROM covid_vaccinations
--ORDER BY 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio..covid_deaths
ORDER BY 1,2;

-- Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in the US
ALTER TABLE covid_deaths ALTER COLUMN total_cases numeric;

ALTER TABLE covid_deaths ALTER COLUMN total_deaths numeric;

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM Portfolio..covid_deaths
WHERE location like '%states%'
ORDER BY 1,2;

-- Total Cases vs Population
-- Shows what percentage of the population got Covid

SELECT location, date, population, total_cases, (total_cases/population)*100 AS percentage_infected
FROM Portfolio..covid_deaths
WHERE location like '%States%'
ORDER BY 1,2;

-- Countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS contraction_percentage
FROM Portfolio..covid_deaths
GROUP BY location, population
ORDER BY contraction_percentage DESC;

-- Showing countries with the highest death count per population

SELECT location, MAX(total_deaths) AS total_death_count
FROM Portfolio..covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;

-- Showing continents with the highest death count

SELECT location, MAX(total_deaths) AS total_death_count
FROM Portfolio..covid_deaths
WHERE continent IS NULL
GROUP BY location
ORDER BY total_death_count DESC;

-- GLOBAL NUMBERS

ALTER TABLE covid_deaths ALTER COLUMN new_deaths int;

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) AS total_deaths, ((SUM(new_deaths))/(SUM(new_cases)))*100 AS death_percentage
FROM Portfolio..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Looking at total populations vs vaccinations

ALTER TABLE covid_vaccinations ALTER COLUMN new_vaccinations numeric;

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) 
OVER (partition by dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated,
--(rolling_people_vaccinated/population)
FROM portfolio..covid_deaths dea
JOIN portfolio..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

-- USE CTE

With PopvsVac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) 
OVER (partition by dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
--(rolling_people_vaccinated/population)*100
FROM portfolio..covid_deaths dea
JOIN portfolio..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

SELECT *,(rolling_people_vaccinated/population)*100 AS rolling_percent_people_vaccinated 
FROM PopvsVac;

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location ORDER by dea.location,
dea.date) as RollinPeopleVaccinated
FROM portfolio..covid_deaths dea
JOIN portfolio..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 

-- Creating View to store data for later visualizations
USE Portfolio
GO
CREATE VIEW rolling_percent_people_vaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (partition by dea.location ORDER by dea.location,
dea.date) as rolling_people_vaccinated
FROM portfolio.dbo.covid_deaths dea
JOIN portfolio.dbo.covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--ORDER by 2,3

SELECT *
FROM rolling_percent_people_vaccinated;

