class Animal {
  [string]$Name
  [string]$Sound

  # 継承元のコンストラクタ
  Animal() {
    $this.Name = '$name'
    $this.Sound = '$sound'
  }
  Animal([string]$name, [string]$sound) {
    $this.Name = $name
    $this.Sound = $sound
  }

  [void]MakeSound() {
    Write-Host "$($this.Name) says $($this.Sound)"
  }
}

class Dog : Animal {
  # 継承先のコンストラクタ
  Dog([string]$name) {
    # 継承元のコンストラクタを呼び出す
    [Animal]::new($name, "Woof")
  }
}

class Cat : Animal {
  # 継承先のコンストラクタ
  Cat([string]$name) {
    # 継承元のコンストラクタを呼び出す
    [Animal]::new($name, "Meow")
  }
}

$dog = [Dog]::new("Spot")
$cat = [Cat]::new("Fluffy")

$dog.MakeSound()
$cat.MakeSound()
