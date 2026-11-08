# Temperature Converter (Flutter)

Enter a temperature, choose a conversion type, press **Convert**.

- Celsius to Fahrenheit: `F = (C × 9/5) + 32`
- Fahrenheit to Celsius: `C = (F − 32) × 5/9`
- Result shown up to 2 decimal places
- Validation: empty input and invalid number show an error message
- No database; state managed with `setState`

## Run
```bash
flutter create .   # first time only
flutter pub get
flutter run
```
