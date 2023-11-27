<?php 

class Region {
    private int $id;
    private string $name;
    private int $area;

    public function getName(): string {
        return $this->name;
    }

    public function getArea(): int {
        return $this->area;
    }

    public function __toString() {
        return $this->name . " region has an area of " . $this->area;
    }
}

class RegionModel {
    public static function getRegionByName(string $name): Region {
        $region = null;
        try {
            $sql = "SELECT * 
                    FROM Region 
                    WHERE name = :name";
            $statement = db()->prepare($sql);
            $statement->bindParam(':name', $name, PDO::PARAM_STR);
            $statement->execute();
            $statement->setFetchMode(PDO::FETCH_CLASS, 'Region');
            $region = $statement->fetch();
        } catch (PDOException $exception) {
            echo $exception->getMessage();
        }
        return $region;
    }
}

