import { test, expect } from '@playwright/test';

// Run before every test

test.beforeEach(async ({ request }) => {
  // hit the cleanup endpoint before every test
  await request.post('/test/cleanup');
});

test.beforeEach(async ({ page }) => {
  await page.goto('/');        // uses baseURL from config
});

test('has title', async ({ page }) => {
  await expect(page.getByRole('heading', { name: 'KofiGainz Progress Tracker' })).toBeVisible();
});

test('user can add a workout session', async ({ page }) => {
  // Fill the add workout form
  await page.getByLabel('Date').fill('2025-12-08');
  await page.getByLabel('Exercise').fill('Barbell Row');
  await page.getByLabel('Sets').fill('3');
  await page.getByLabel('Reps').fill('12');
  await page.getByLabel('Weight (kg)').fill('100');

  await page.getByRole('button', { name: 'Save workout' }).click();

  await expect(page.getByText('Workout entry added!')).toBeVisible();

  const row = page.getByRole('row', { name: /Barbell Row/ }).last();
  await expect(row).toBeVisible();
  await expect(row).toContainText('3');
  await expect(row).toContainText('12');
  await expect(row).toContainText('100');
});

// test for validation errors

test('shows validation errors when form is empty', async ({ page }) => {
  await page.getByRole('button', { name: 'Save workout' }).click();

  await expect(
    page.getByText("Exercise name can't be blank")).toBeVisible();

  await expect(
    page.getByText("Performed on can't be blank")).toBeVisible();
});

// Test for search filters
test('search filters workout history by exercise name', async ({ page }) => {
  // Precondition: create two workouts
  await page.getByLabel('Date').fill('2025-12-08');
  await page.getByLabel('Exercise').fill('Bench Press');
  await page.getByLabel('Sets').fill('3');
  await page.getByLabel('Reps').fill('8');
  await page.getByLabel('Weight (kg)').fill('80');
  await page.getByRole('button', { name: 'Save workout' }).click();

  await page.getByLabel('Date').fill('2025-12-08');
  await page.getByLabel('Exercise').fill('Squat');
  await page.getByLabel('Sets').fill('5');
  await page.getByLabel('Reps').fill('5');
  await page.getByLabel('Weight (kg)').fill('100');
  await page.getByRole('button', { name: 'Save workout' }).click();

  // Use the search field in the header
  await page.getByPlaceholder('Search exercise...').fill('bench');
  await page.getByRole('button', { name: 'Apply' }).click();

 await expect(page.getByRole('cell', { name: 'Bench Press' }).first()).toBeVisible();
 await expect(page.getByRole('cell', { name: 'Squat' })).toHaveCount(0);

  // Clear search (adjust selector if your UI is different)
  await page.getByRole('link', { name: 'Clear' }).click();
  await expect(page.getByText('Squat')).toBeVisible();
});





