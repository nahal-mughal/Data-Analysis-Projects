#BMI calculator

weight = int(input("Enter your weight in pounds: "))
height = int(input("Enter your height in inches: "))

bodymassindex ="%.2f" % ((weight * 703) / (height * height))

BMI = float(bodymassindex)

print("Your BMI is: "+ bodymassindex)
      
if (BMI>0):
    if (BMI<18.5):
        print("You're underweight")
    elif (BMI>=18.5 and BMI<25.0):
        print("You're normal weight")
    elif (BMI>=25.0 and BMI<30.0):
        print("You're overweight")
    elif (BMI>=30.0 and BMI<35.0):
        print("You're obese")
    elif (BMI>=35.0 and BMI<40.0):
        print("You're severly obese")
    else:
        print("You're extremely obese")
else:
    print("Invalid input")
