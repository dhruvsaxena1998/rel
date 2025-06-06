package translator_test

import (
	"encoding/json"
	"testing"

	"github.com/dhruvsaxena1998/rel/internal/lexer"
	"github.com/dhruvsaxena1998/rel/internal/parser"
	translator "github.com/dhruvsaxena1998/rel/internal/translator/jsonlogic"
)

func jsonEqual(a, b map[string]any) bool {
	aJSON, _ := json.Marshal(a)
	bJSON, _ := json.Marshal(b)
	return string(aJSON) == string(bJSON)
}

func BenchmarkTranslateToJSONLogic(b *testing.B) {

	inputs := []string{
		"1 == 1",
		"1 < 2 and 3 > 2",
		"1 == 0 or (5 < 10 and 5 > 0)",
		"@price < 100",
		"@fruit in ['apple', 'banana', 'orange']",
		"@temp < 30 and @humidity > 50 and (@weather == 'sunny' or @weather == 'cloudy')",
	}

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		input := inputs[i%len(inputs)]
		translator.TranslateToJSONLogic(
			parser.Parse(
				lexer.Tokenize(input),
			),
		)
	}
}

func TestTranslateIfExpression(t *testing.T) {
	input := `if { @age < 18: 'kid'; @age < 55: 'adult'; } else 'old'`
	parsed := parser.Parse(lexer.Tokenize(input))
	result := translator.TranslateToJSONLogic(parsed)

	expected := map[string]any{
		"if": []any{
			map[string]any{"<": []any{map[string]any{"var": "age"}, 18}}, "kid",
			map[string]any{"<": []any{map[string]any{"var": "age"}, 55}}, "adult",
			"old",
		},
	}

	if !jsonEqual(result, expected) {
		t.Errorf("TranslateToJSONLogic(if) = %v, want %v", result, expected)
	}

}
